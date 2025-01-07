import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/chat/domain/chat_message.dart';
import 'package:repore_chat/utils/enums.dart';

final chatProvider = AutoDisposeNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>(ChatNotifier.new);

class ChatNotifier extends AutoDisposeNotifier<AsyncValue<List<ChatMessage>>> {
  late final String groupId;
  late final FirebaseDatabase _database;
  late final DatabaseReference _messagesRef;
  late final DatabaseReference _groupRef;
  StreamSubscription<DatabaseEvent>? _messagesSubscription;
  StreamSubscription<DatabaseEvent>? _presenceSubscription;

  @override
  AsyncValue<List<ChatMessage>> build() {
    _database = FirebaseDatabase.instance;
    return const AsyncValue.loading();
  }

  void startListening(String groupId) {
    this.groupId = groupId;
    _messagesRef = _database.ref().child('messages').child(groupId);
    _groupRef = _database.ref().child('groups').child(groupId);

    _setupMessageListener();
    _setupMessageStatusUpdateListener();
  }

  void _setupMessageListener() {
    _messagesSubscription?.cancel();
    _messagesSubscription = _messagesRef.orderByChild('timestamp').onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
          final messages = messagesMap.entries.map((e) {
            final data = Map<String, dynamic>.from(e.value as Map);
            data['key'] = e.key;
            return ChatMessage.fromJson(data);
          }).toList();
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          state = AsyncValue.data(messages);
        } else {
          state = const AsyncValue.data([]);
        }
      },
      onError: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  void _setupMessageStatusUpdateListener() {
    final user = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    if (user == null) return;

    _presenceSubscription?.cancel();

    _presenceSubscription = _messagesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;

        for (final entry in messagesMap.entries) {
          final message = Map<String, dynamic>.from(entry.value as Map);
          final status = message['status'] as String?;

          if (status == Status.sent.name && message['senderId'] != user.id) {
            _messagesRef.child(entry.key).update({
              'status': Status.delivered.name,
            });
          }
        }
      }
    });
  }

  Future<void> sendMessage(String message) async {
    try {
      final user = ref.read(authProvider).maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );

      if (user == null) {
        throw Exception('You must be logged in to send messages');
      }

      final timestamp = DateTime.now();
      final senderName = user.displayName ?? user.email;

      final newMessageRef = _messagesRef.push();
      final newMessage = ChatMessage(
        groupId: groupId,
        senderId: user.id,
        senderName: senderName,
        message: message,
        timestamp: timestamp,
        senderRole: user.role,
        status: Status.waiting,
        key: newMessageRef.key,
      );

      try {
        await newMessageRef.set(newMessage.toJson());
        await newMessageRef.update({'status': Status.sent.name});

        await _groupRef.update({
          'lastMessage': '$senderName: $message',
          'lastMessageTime': timestamp.toIso8601String(),
        });
      } catch (e) {
        final failedMessage = newMessage.copyWith(status: Status.resend);
        state = AsyncValue.data([...state.value ?? [], failedMessage]);
        rethrow;
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
