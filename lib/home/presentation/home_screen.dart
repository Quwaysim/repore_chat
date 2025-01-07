import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/home/application/chat_group_notifier.dart';
import 'package:repore_chat/home/presentation/create_group_screen.dart';
import 'package:repore_chat/chat/presentation/chat_screen.dart';
import 'package:repore_chat/utils/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(chatGroupProvider);
    final currentUser = ref.watch(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Welcome, ${currentUser?.displayName ?? currentUser?.email}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateGroupScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: groupsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (groups) {
          if (groups.isEmpty) {
            return const NoChatsYet();
          }

          return ListView.separated(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group.name),
                subtitle: group.lastMessage != null
                    ? Text(
                        group.lastMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const Text('No messages yet'),
                leading: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: const Icon(Icons.people),
                  ),
                ),
                trailing: group.lastMessageTime != null
                    ? Text(
                        '${group.lastMessageTime!.hour}:${group.lastMessageTime!.minute}',
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(groupId: group.id, groupName: group.name),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}

class NoChatsYet extends StatelessWidget {
  const NoChatsYet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Center(
        child: Text(
          'You have no chats yet. Please click on the add button in the top right to create a group and start chatting :-)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
