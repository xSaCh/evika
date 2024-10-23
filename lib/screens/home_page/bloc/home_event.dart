part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeNextEvents extends HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeLikeEvent extends HomeEvent {
  final int index;
  HomeLikeEvent(this.index);
}

class HomeCommentEvent extends HomeEvent {
  final int index;
  final String comment;
  HomeCommentEvent(this.index, this.comment);
}

class HomeSavedEvent extends HomeEvent {
  final int index;
  HomeSavedEvent(this.index);
}
