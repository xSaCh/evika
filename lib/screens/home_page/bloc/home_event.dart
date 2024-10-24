// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeNextEvents extends HomeEvent {}

class HomeSearchEvent extends HomeEvent {
  String query;
  HomeSearchEvent(this.query);
}

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
