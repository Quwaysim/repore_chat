import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/auth/domain/user.dart';
import 'package:repore_chat/utils/enums.dart';

final presenceProvider = Provider.autoDispose((ref) {
  final notifier = PresenceNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

class PresenceNotifier {
  PresenceNotifier(this.ref) {
    _setupMessageListener();
  }

  final Ref ref;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<DatabaseEvent>? _presenceSubscription;

  void dispose() {
    _presenceSubscription?.cancel();
  }

  void _setupMessageListener() {
    final user = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    if (user == null) return;

    final messagesRef = _database.ref().child('messages');

    _presenceSubscription?.cancel();
    _presenceSubscription = messagesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _updateMessageStatuses(user);
      }
    });
  }

  void _updateMessageStatuses(User user) {
    final messagesRef = _database.ref().child('messages');
    messagesRef.get().then((snapshot) {
      if (snapshot.value != null) {
        final groupsMap = snapshot.value as Map<dynamic, dynamic>;

        for (final groupEntry in groupsMap.entries) {
          final messagesMap = groupEntry.value as Map<dynamic, dynamic>;

          for (final messageEntry in messagesMap.entries) {
            final message = Map<String, dynamic>.from(messageEntry.value as Map);
            final status = message['status'] as String?;

            if (status == Status.sent.name && message['senderId'] != user.id) {
              messagesRef.child(groupEntry.key).child(messageEntry.key).update({
                'status': Status.delivered.name,
              });
            }
          }
        }
      }
    });
  }
}
