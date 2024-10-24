part of 'like_bloc.dart';

class LikeState {
  List<Event> events;
  LoginUser? loginUser;
  LikeState({required this.events, this.loginUser});

  LikeState.empty() : events = [];

  LikeState copyWith({List<Event>? events, LoginUser? loginUser}) {
    return LikeState(
      events: events ?? this.events,
      loginUser: loginUser ?? this.loginUser,
    );
  }
}

class LikeFailureState extends LikeState {
  String errorMsg;
  LikeFailureState({required super.events, required this.errorMsg, super.loginUser});
}

class LikeNoMoreEventsState extends LikeState {
  LikeNoMoreEventsState({required super.events, super.loginUser});
}
