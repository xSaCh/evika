import 'package:bloc/bloc.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Repository repo;
  int nextPage;
  int totalPages;

  HomeBloc(this.repo)
      : nextPage = 1,
        totalPages = 0,
        super(HomeState.empty()) {
    on<HomeInitialEvent>(_handleInitialEvent);
    on<HomeLikeEvent>(_handleLikeEvent);
    on<HomeCommentEvent>(_handleCommentEvent);
    on<HomeSavedEvent>(_handleSavedEvent);
    on<HomeNextEvents>(_handleNextEvent);
  }

  void _handleInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
    try {
      final r = await repo.getEvents();
      nextPage++;
      totalPages = r.$2;
      emit(state.copyWith(events: r.$1));
    } catch (e) {
      // emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
      debugPrint("Cached Response");
      final events = repo.getEventsCached();
      emit(HomeFailureState(events: events, errorMsg: "Showing cached events"));
    }
  }

  void _handleLikeEvent(HomeLikeEvent event, Emitter<HomeState> emit) async {
    try {
      var events = state.events;
      events[event.index].isLiked = !events[event.index].isLiked;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleCommentEvent(HomeCommentEvent event, Emitter<HomeState> emit) async {
    try {
      var events = state.events;
      events[event.index].myComment =
          events[event.index].myComment.isNotEmpty ? "" : event.comment;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleSavedEvent(HomeSavedEvent event, Emitter<HomeState> emit) async {
    try {
      var events = state.events;
      events[event.index].isSaved = !events[event.index].isSaved;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleNextEvent(HomeNextEvents event, Emitter<HomeState> emit) async {
    try {
      if (nextPage > totalPages) {
        emit(HomeNoMoreEventsState(events: state.events, loginUser: state.loginUser));
        return;
      }
      var newEvents = await repo.getEvents(page: nextPage);
      // Assuming Total pages might change during fetching next pages
      totalPages = newEvents.$2;
      nextPage++;

      emit(state.copyWith(events: state.events..addAll(newEvents.$1)));
    } catch (e) {
      emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }
}
