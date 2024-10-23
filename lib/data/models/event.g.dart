// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      user: fields[0] as User,
      description: fields[1] as String,
      title: fields[2] as String,
      imageUrls: (fields[3] as List).cast<String>(),
      likedUsersId: (fields[4] as List).cast<String>(),
      comments: (fields[5] as List).cast<String>(),
      eventCategory: (fields[6] as List).cast<String>(),
      eventStartAt: fields[7] as DateTime,
      eventEndAt: fields[8] as DateTime,
      registrationRequired: fields[9] as bool,
      keywords: (fields[10] as List).cast<String>(),
      hashTags: (fields[11] as List).cast<String>(),
      registration: (fields[12] as List).cast<String>(),
      likes: fields[13] as int,
      isLiked: fields[14] as bool,
      myComment: fields[15] as String,
      isSaved: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.imageUrls)
      ..writeByte(4)
      ..write(obj.likedUsersId)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.eventCategory)
      ..writeByte(7)
      ..write(obj.eventStartAt)
      ..writeByte(8)
      ..write(obj.eventEndAt)
      ..writeByte(9)
      ..write(obj.registrationRequired)
      ..writeByte(10)
      ..write(obj.keywords)
      ..writeByte(11)
      ..write(obj.hashTags)
      ..writeByte(12)
      ..write(obj.registration)
      ..writeByte(13)
      ..write(obj.likes)
      ..writeByte(14)
      ..write(obj.isLiked)
      ..writeByte(15)
      ..write(obj.myComment)
      ..writeByte(16)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
