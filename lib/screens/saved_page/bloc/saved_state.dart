part of 'saved_bloc.dart';

class SavedState {
  List<Event> events;
  LoginUser? loginUser;
  SavedState({required this.events, this.loginUser});

  SavedState.empty() : events = [];

  SavedState copyWith({List<Event>? events, LoginUser? loginUser}) {
    return SavedState(
      events: events ?? this.events,
      loginUser: loginUser ?? this.loginUser,
    );
  }
}

class SavedFailureState extends SavedState {
  String errorMsg;
  SavedFailureState({required super.events, required this.errorMsg, super.loginUser});
}

class SavedNoMoreEventsState extends SavedState {
  SavedNoMoreEventsState({required super.events, super.loginUser});
}
