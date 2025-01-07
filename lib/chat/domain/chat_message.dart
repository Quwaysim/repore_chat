import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repore_chat/utils/enums.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String message,
    required DateTime timestamp,
    required Role senderRole,
    @Default(Status.sent) Status status,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
