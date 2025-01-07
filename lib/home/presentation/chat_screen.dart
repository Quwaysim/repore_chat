import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/chat/application/chat_notifier.dart';
import 'package:repore_chat/utils/app_colors.dart';
import 'package:repore_chat/utils/asset_paths.dart';
import 'package:repore_chat/utils/enums.dart';
import 'package:repore_chat/utils/helpers.dart';
import 'package:repore_chat/utils/widgets/chat_bubble.dart';
import 'package:repore_chat/utils/widgets/chat_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.groupId, required this.groupName});

  final String groupId;
  final String groupName;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).startListening(widget.groupId);
      _markMessagesAsRead();
    });
  }

  void _markMessagesAsRead() {
    final user = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    if (user == null) return;

    final messages = ref.read(chatProvider).value ?? [];
    for (final message in messages) {
      if (message.senderId != user.id && message.status != Status.read) {
        FirebaseDatabase.instance
            .ref()
            .child('messages')
            .child(widget.groupId)
            .child(message.key ?? '')
            .update({'status': Status.read.name});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(chatProvider, (previous, next) {
      if (next.hasValue) {
        _markMessagesAsRead();
      }
    });

    final currentUser = ref.watch(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            AssetPaths.icBack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 32.w,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. You can start the conversation!'),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message.senderId == currentUser?.id;

                    return ChatBubble(
                      userName: message.senderName,
                      time: formatTime(message.timestamp),
                      message: message.message,
                      status: message.status,
                      isMe: isMe,
                      role: message.senderRole,
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(
            textController: _messageController,
            onSend: () {
              if (_messageController.text.trim().isNotEmpty) {
                ref.read(chatProvider.notifier).sendMessage(
                      _messageController.text.trim(),
                    );
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
