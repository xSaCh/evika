import 'package:bloc/bloc.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  Repository repo;
  int nextPage;
  int totalPages;

  SavedBloc(this.repo)
      : nextPage = 1,
        totalPages = 0,
        super(SavedState.empty()) {
    on<SavedInitialEvent>(_handleInitialEvent);
    on<SavedLikeEvent>(_handleLikeEvent);
    on<SavedCommentEvent>(_handleCommentEvent);
    on<SavedSavedEvent>(_handleSavedEvent);
    on<SavedNextEvents>(_handleNextEvent);
  }

  void _handleInitialEvent(SavedInitialEvent event, Emitter<SavedState> emit) async {
    try {
      final r = await repo.getEvents();

      nextPage++;
      totalPages = r.$2;
      emit(state.copyWith(events: r.$1.where((e) => e.isSaved).toList()));
    } catch (e) {
      // emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
      debugPrint("Cached Response");
      final events = repo.getEventsCached();
      emit(state.copyWith(events: events));
    }
  }

  void _handleLikeEvent(SavedLikeEvent event, Emitter<SavedState> emit) async {
    try {
      var events = state.events;
      events[event.index].isLiked = !events[event.index].isLiked;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(SavedFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleCommentEvent(SavedCommentEvent event, Emitter<SavedState> emit) async {
    try {
      var events = state.events;
      events[event.index].myComment = event.comment;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(SavedFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleSavedEvent(SavedSavedEvent event, Emitter<SavedState> emit) async {
    try {
      var events = state.events;
      events[event.index].isSaved = !events[event.index].isSaved;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(SavedFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleNextEvent(SavedNextEvents event, Emitter<SavedState> emit) async {
    try {
      if (nextPage > totalPages) {
        emit(SavedNoMoreEventsState(events: state.events, loginUser: state.loginUser));
        return;
      }
      var newEvents = await repo.getEvents(page: nextPage);
      // Assuming Total pages might change during fetching next pages
      totalPages = newEvents.$2;
      nextPage++;

      emit(state.copyWith(
          events: state.events..addAll(newEvents.$1.where((e) => e.isSaved).toList())));
    } catch (e) {
      emit(SavedFailureState(events: state.events, errorMsg: e.toString()));
    }
  }
}
