import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_state.dart';
import 'package:repore_chat/auth/domain/user.dart';
import 'package:repore_chat/utils/helpers.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late final firebase.FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  @override
  AuthState build() {
    _auth = firebase.FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(User.fromFirebase(user));
      } else {
        state = const AuthState.unauthenticated();
      }
    });
    return const AuthState.initial();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = const AuthState.loading();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String username, String email, String password) async {
    try {
      state = const AuthState.loading();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        debugPrint('Error: User is null after creation');
        state = AuthState.error(_mapFirebaseError(''));
        return;
      }

      await user.updateDisplayName(username);

      final userData = User(
        id: user.uid,
        email: email,
        displayName: username,
        role: getRoleFromEmail(email),
      );

      try {
        await _firestore.collection('users').doc(user.uid).set(userData.toJson());
      } catch (e) {
        state = AuthState.error(_mapFirebaseError(e.toString()));
        return;
      }

    } on firebase.FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e.code));
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'invalids-email':
        return 'The email address is invalid.';
      case 'invalid-credential':
        return 'Invalid login details provided.';
      default:
        return capitalizeFirstLetter(code.replaceAll('-', ' '));
    }
  }
}
