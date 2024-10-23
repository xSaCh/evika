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
      id: fields[0] as String,
      user: fields[1] as User,
      description: fields[2] as String,
      title: fields[3] as String,
      imageUrls: (fields[4] as List).cast<String>(),
      likedUsersId: (fields[5] as List).cast<String>(),
      comments: (fields[6] as List).cast<String>(),
      eventCategory: (fields[7] as List).cast<String>(),
      eventStartAt: fields[8] as DateTime,
      eventEndAt: fields[9] as DateTime,
      registrationRequired: fields[10] as bool,
      keywords: (fields[11] as List).cast<String>(),
      hashTags: (fields[12] as List).cast<String>(),
      registration: (fields[13] as List).cast<String>(),
      likes: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.imageUrls)
      ..writeByte(5)
      ..write(obj.likedUsersId)
      ..writeByte(6)
      ..write(obj.comments)
      ..writeByte(7)
      ..write(obj.eventCategory)
      ..writeByte(8)
      ..write(obj.eventStartAt)
      ..writeByte(9)
      ..write(obj.eventEndAt)
      ..writeByte(10)
      ..write(obj.registrationRequired)
      ..writeByte(11)
      ..write(obj.keywords)
      ..writeByte(12)
      ..write(obj.hashTags)
      ..writeByte(13)
      ..write(obj.registration)
      ..writeByte(14)
      ..write(obj.likes);
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
