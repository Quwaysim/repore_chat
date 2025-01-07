import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_group.freezed.dart';
part 'chat_group.g.dart';

@freezed
class ChatGroup with _$ChatGroup {
  const factory ChatGroup({
    required String id,
    required String name,
    required String createdBy,
    required DateTime createdAt,
    required Map<String, bool> members,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) = _ChatGroup;

  factory ChatGroup.fromJson(Map<String, dynamic> json) => _$ChatGroupFromJson(json);
}
