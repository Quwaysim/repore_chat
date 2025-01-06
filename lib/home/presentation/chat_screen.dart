import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/auth/presentation/login_screen.dart';
import 'package:repore_chat/utils/app_colors.dart';
import 'package:repore_chat/utils/asset_paths.dart';
import 'package:repore_chat/utils/enums.dart';
import 'package:repore_chat/utils/widgets/chat_bubble.dart';
import 'package:repore_chat/utils/widgets/chat_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<ChatBubble> messages = [
    const ChatBubble(
      userName: 'John Doe',
      time: '10:30 AM',
      message: 'Hi there, how are you?',
      status: Status.read,
      isMe: false,
      role: Role.admin,
    ),
    const ChatBubble(
      userName: 'Alice Smith',
      time: '10:30 AM',
      message: 'Hi, I\'m fine, thanks!',
      status: Status.resend,
      isMe: true,
      role: Role.customer,
    ),
    const ChatBubble(
      userName: 'Imran Khan',
      time: '10:30 AM',
      message: 'It\'s nice to meet you!',
      status: Status.delivered,
      isMe: false,
      role: Role.agent,
    ),
    const ChatBubble(
      userName: 'John Doe',
      time: '10:30 AM',
      message: 'Hi there, how are you?',
      status: Status.read,
      isMe: false,
      role: Role.admin,
    ),
  ];

  void _addMessage(String message) {
    final currentUser = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    if (currentUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final hour = now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    final formattedTime = '$hour:$minute $period';
    final displayName = currentUser.displayName ?? '';
    final email = currentUser.email;
    final userName = displayName.isNotEmpty ? displayName : email;

    setState(() {
      messages.insert(
        0,
        ChatBubble(
          userName: userName,
          time: formattedTime,
          message: message,
          status: Status.sent,
          isMe: true,
          role: Role.customer,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorF9FAFB,
      appBar: AppBar(
        title: const Text(
          'Group Name',
          style: TextStyle(color: Colors.white),
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
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.colorF9FAFB,
              ),
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
              ),
            ),
          ),
          ChatInput(
            onSend: _addMessage,
          ),
        ],
      ),
    );
  }
}
