import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repore_chat/auth/application/auth_state.dart';
import 'package:repore_chat/auth/domain/user.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late final firebase.FirebaseAuth _auth;

  @override
  AuthState build() {
    _auth = firebase.FirebaseAuth.instance;
    _setupAuthStateListener();
    return const AuthState.initial();
  }

  void _setupAuthStateListener() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        try {
          state = AuthState.authenticated(User.fromFirebase(user));
        } catch (e) {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    });
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

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      state = const AuthState.loading();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user has been disabled';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'email-already-in-use':
        return 'Email already in use';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
