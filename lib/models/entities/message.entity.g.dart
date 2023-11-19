// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      authorId: json['authorId'] as String,
      authorUsername: json['authorUsername'] as String,
      text: json['text'] as String,
      verifiedOnly: json['verifiedOnly'] as bool,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'authorId': instance.authorId,
      'authorUsername': instance.authorUsername,
      'text': instance.text,
      'verifiedOnly': instance.verifiedOnly,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
