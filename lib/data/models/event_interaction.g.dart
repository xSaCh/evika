// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_interaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventInteractionAdapter extends TypeAdapter<EventInteraction> {
  @override
  final int typeId = 2;

  @override
  EventInteraction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventInteraction(
      eventId: fields[0] as String,
      isLiked: fields[1] as bool,
      myComment: fields[2] as String,
      isSaved: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EventInteraction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.isLiked)
      ..writeByte(2)
      ..write(obj.myComment)
      ..writeByte(3)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventInteractionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
