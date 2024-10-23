// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  List<Event> events;
  LoginUser? loginUser;
  HomeState({required this.events, this.loginUser});

  HomeState.empty() : events = [];

  HomeState copyWith({List<Event>? events, LoginUser? loginUser}) {
    return HomeState(
      events: events ?? this.events,
      loginUser: loginUser ?? this.loginUser,
    );
  }
}

class HomeFailureState extends HomeState {
  String errorMsg;
  HomeFailureState({required super.events, required this.errorMsg, super.loginUser});
}

class HomeNoMoreEventsState extends HomeState {
  HomeNoMoreEventsState({required super.events, super.loginUser});
}
