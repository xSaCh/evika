// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState {
  List<Event> events;
  LoginUser? loginUser;
  Set<String> uniqueCategories;
  List<String> selectedCategories;

  HomeState(
      {required this.events,
      this.loginUser,
      Set<String>? uniqueCategories,
      List<String>? selectedCategories})
      : uniqueCategories = uniqueCategories ?? {},
        selectedCategories = selectedCategories ?? [];

  HomeState.empty()
      : events = [],
        uniqueCategories = {},
        selectedCategories = [];

  HomeState copyWith(
      {List<Event>? events,
      LoginUser? loginUser,
      Set<String>? uniqueCategories,
      List<String>? selectedCategories}) {
    return HomeState(
      events: events ?? this.events,
      loginUser: loginUser ?? this.loginUser,
      uniqueCategories: uniqueCategories ?? this.uniqueCategories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
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
