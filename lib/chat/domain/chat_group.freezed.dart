// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatGroup _$ChatGroupFromJson(Map<String, dynamic> json) {
  return _ChatGroup.fromJson(json);
}

/// @nodoc
mixin _$ChatGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, bool> get members => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageTime => throw _privateConstructorUsedError;

  /// Serializes this ChatGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatGroupCopyWith<ChatGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatGroupCopyWith<$Res> {
  factory $ChatGroupCopyWith(ChatGroup value, $Res Function(ChatGroup) then) =
      _$ChatGroupCopyWithImpl<$Res, ChatGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      String createdBy,
      DateTime createdAt,
      Map<String, bool> members,
      String? lastMessage,
      DateTime? lastMessageTime});
}

/// @nodoc
class _$ChatGroupCopyWithImpl<$Res, $Val extends ChatGroup>
    implements $ChatGroupCopyWith<$Res> {
  _$ChatGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? members = null,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatGroupImplCopyWith<$Res>
    implements $ChatGroupCopyWith<$Res> {
  factory _$$ChatGroupImplCopyWith(
          _$ChatGroupImpl value, $Res Function(_$ChatGroupImpl) then) =
      __$$ChatGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String createdBy,
      DateTime createdAt,
      Map<String, bool> members,
      String? lastMessage,
      DateTime? lastMessageTime});
}

/// @nodoc
class __$$ChatGroupImplCopyWithImpl<$Res>
    extends _$ChatGroupCopyWithImpl<$Res, _$ChatGroupImpl>
    implements _$$ChatGroupImplCopyWith<$Res> {
  __$$ChatGroupImplCopyWithImpl(
      _$ChatGroupImpl _value, $Res Function(_$ChatGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? members = null,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
  }) {
    return _then(_$ChatGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _value.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatGroupImpl implements _ChatGroup {
  const _$ChatGroupImpl(
      {required this.id,
      required this.name,
      required this.createdBy,
      required this.createdAt,
      required final Map<String, bool> members,
      this.lastMessage,
      this.lastMessageTime})
      : _members = members;

  factory _$ChatGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  final Map<String, bool> _members;
  @override
  Map<String, bool> get members {
    if (_members is EqualUnmodifiableMapView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_members);
  }

  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageTime;

  @override
  String toString() {
    return 'ChatGroup(id: $id, name: $name, createdBy: $createdBy, createdAt: $createdAt, members: $members, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      createdBy,
      createdAt,
      const DeepCollectionEquality().hash(_members),
      lastMessage,
      lastMessageTime);

  /// Create a copy of ChatGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatGroupImplCopyWith<_$ChatGroupImpl> get copyWith =>
      __$$ChatGroupImplCopyWithImpl<_$ChatGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatGroupImplToJson(
      this,
    );
  }
}

abstract class _ChatGroup implements ChatGroup {
  const factory _ChatGroup(
      {required final String id,
      required final String name,
      required final String createdBy,
      required final DateTime createdAt,
      required final Map<String, bool> members,
      final String? lastMessage,
      final DateTime? lastMessageTime}) = _$ChatGroupImpl;

  factory _ChatGroup.fromJson(Map<String, dynamic> json) =
      _$ChatGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  Map<String, bool> get members;
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageTime;

  /// Create a copy of ChatGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatGroupImplCopyWith<_$ChatGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
