// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:evika/data/models/event.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'event_interaction.g.dart';

@HiveType(typeId: 2)
class EventInteraction {
  @HiveField(0)
  String eventId;
  @HiveField(1)
  bool isLiked;
  @HiveField(2)
  String myComment;
  @HiveField(3)
  bool isSaved;

  EventInteraction({
    required this.eventId,
    this.isLiked = false,
    this.myComment = "",
    this.isSaved = false,
  });

  EventInteraction.fromEvent(Event event)
      : eventId = event.id,
        isLiked = event.isLiked,
        myComment = event.myComment,
        isSaved = event.isSaved;
}
