part of 'like_bloc.dart';

@immutable
sealed class LikeEvent {}

class LikeNextEvents extends LikeEvent {}

class LikeInitialEvent extends LikeEvent {}

class LikeLikeEvent extends LikeEvent {
  final int index;
  LikeLikeEvent(this.index);
}

class LikeCommentEvent extends LikeEvent {
  final int index;
  final String comment;
  LikeCommentEvent(this.index, this.comment);
}

class LikeSavedEvent extends LikeEvent {
  final int index;
  LikeSavedEvent(this.index);
}
