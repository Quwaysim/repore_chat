// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderRole: $enumDecode(_$RoleEnumMap, json['senderRole']),
      status: $enumDecode(_$StatusEnumMap, json['status']),
      key: json['key'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'senderRole': _$RoleEnumMap[instance.senderRole]!,
      'status': _$StatusEnumMap[instance.status]!,
      'key': instance.key,
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.customer: 'customer',
  Role.agent: 'agent',
};

const _$StatusEnumMap = {
  Status.waiting: 'waiting',
  Status.sent: 'sent',
  Status.resend: 'resend',
  Status.delivered: 'delivered',
  Status.read: 'read',
};
