import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.entity.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class MessageEntity{
  String authorId;
  String authorUsername;
  String text;
  bool verifiedOnly;
  @TimestampConverter()
  DateTime createdAt;
  @TimestampConverter()
  DateTime updatedAt;

  MessageEntity({
    required this.authorId,
    required this.authorUsername,
    required this.text,
    required this.verifiedOnly,
    required this.createdAt,
    required this.updatedAt
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}