import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/chat/domain/chat_group.dart';

final chatGroupProvider =
    AutoDisposeNotifierProvider<ChatGroupNotifier, AsyncValue<List<ChatGroup>>>(ChatGroupNotifier.new);

class ChatGroupNotifier extends AutoDisposeNotifier<AsyncValue<List<ChatGroup>>> {
  late final FirebaseDatabase _database;
  late final DatabaseReference _groupsRef;
  late final FirebaseFirestore _firestore;
  StreamSubscription<DatabaseEvent>? _groupsSubscription;

  @override
  AsyncValue<List<ChatGroup>> build() {
    _database = FirebaseDatabase.instance;
    _groupsRef = _database.ref().child('groups');
    _firestore = FirebaseFirestore.instance;

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) => _startListening(user.id),
        orElse: () {
          _groupsSubscription?.cancel();
          state = const AsyncValue.data([]);
        },
      );
    });

    final currentUser = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );

    if (currentUser != null) {
      _startListening(currentUser.id);
    }

    return const AsyncValue.loading();
  }

  void _startListening(String userId) {
    _groupsSubscription?.cancel();
    _groupsSubscription = _groupsRef.orderByChild('members/$userId').equalTo(true).onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final groupsMap = event.snapshot.value as Map<dynamic, dynamic>;
          final groups = groupsMap.entries.map((entry) {
            final groupData = Map<String, dynamic>.from(entry.value);
            groupData['id'] = entry.key;
            return ChatGroup.fromJson(groupData);
          }).toList();

          state = AsyncValue.data(groups);
        } else {
          state = const AsyncValue.data([]);
        }
      },
      onError: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> createGroup(String name, String memberEmails) async {
    try {
      state = const AsyncValue.loading();

      final memberIds = await _getMemberIdsFromEmails(memberEmails);

      if (memberIds.isEmpty) {
        throw Exception('No valid member emails provided');
      }

      final currentUser = ref.read(authProvider).maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );

      if (currentUser == null) {
        throw Exception('You must be logged in to create a group');
      }

      final members = {currentUser.id: true};
      for (final memberId in memberIds) {
        members[memberId] = true;
      }

      final newGroup = ChatGroup(
        id: '',
        name: name,
        createdBy: currentUser.id,
        createdAt: DateTime.now(),
        members: Map<String, bool>.from(members),
      );

      await _groupsRef.push().set(newGroup.toJson());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<List<String>> _getMemberIdsFromEmails(String memberEmails) async {
    if (memberEmails.trim().isEmpty) return [];

    final emails = memberEmails.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final memberIds = <String>[];

    for (final email in emails) {
      final querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        memberIds.add(querySnapshot.docs.first.id);
      }
    }

    return memberIds;
  }

  Future<void> addMemberToGroup(String groupId, String memberId) async {
    try {
      await _groupsRef.child(groupId).child('members/$memberId').set(true);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    try {
      await _groupsRef.child(groupId).child('members/$memberId').remove();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
