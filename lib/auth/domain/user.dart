import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repore_chat/utils/enums.dart';
import 'package:repore_chat/utils/helpers.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    required Role role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirebase(firebase.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      role: getRoleFromEmail(user.email ?? ''),
    );
  }
}
