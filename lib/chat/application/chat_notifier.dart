import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/chat/domain/chat_message.dart';

final chatProvider = AutoDisposeNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>(ChatNotifier.new);

class ChatNotifier extends AutoDisposeNotifier<AsyncValue<List<ChatMessage>>> {
  late final String groupId;
  late final FirebaseDatabase _database;
  late final DatabaseReference _messagesRef;
  late final DatabaseReference _groupRef;
  StreamSubscription<DatabaseEvent>? _messagesSubscription;

  @override
  AsyncValue<List<ChatMessage>> build() {
    _database = FirebaseDatabase.instance;
    return const AsyncValue.loading();
  }

  void startListening(String groupId) {
    this.groupId = groupId;
    _messagesRef = _database.ref().child('messages').child(groupId);
    _groupRef = _database.ref().child('groups').child(groupId);
    _messagesSubscription?.cancel();
    _messagesSubscription = _messagesRef.orderByChild('timestamp').onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
          final messages = messagesMap.entries.map((e) {
            final data = Map<String, dynamic>.from(e.value as Map);
            data['id'] = e.key;
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
      final newMessage = ChatMessage(
        groupId: groupId,
        senderId: user.id,
        senderName: senderName,
        message: message,
        timestamp: timestamp,
        senderRole: user.role,
      );

      await _messagesRef.push().set(newMessage.toJson());

      await _groupRef.update({
        'lastMessage': '$senderName: $message',
        'lastMessageTime': timestamp.toIso8601String(),
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
