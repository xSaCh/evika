part of 'saved_bloc.dart';

@immutable
sealed class SavedEvent {}

class SavedNextEvents extends SavedEvent {}

class SavedInitialEvent extends SavedEvent {}

class SavedLikeEvent extends SavedEvent {
  final int index;
  SavedLikeEvent(this.index);
}

class SavedCommentEvent extends SavedEvent {
  final int index;
  final String comment;
  SavedCommentEvent(this.index, this.comment);
}

class SavedSavedEvent extends SavedEvent {
  final int index;
  SavedSavedEvent(this.index);
}
