import 'package:bloc/bloc.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  Repository repo;
  int nextPage;
  int totalPages;

  LikeBloc(this.repo)
      : nextPage = 1,
        totalPages = 0,
        super(LikeState.empty()) {
    on<LikeInitialEvent>(_handleInitialEvent);
    on<LikeLikeEvent>(_handleLikeEvent);
    on<LikeCommentEvent>(_handleCommentEvent);
    on<LikeSavedEvent>(_handleSavedEvent);
    on<LikeNextEvents>(_handleNextEvent);
  }

  void _handleInitialEvent(LikeInitialEvent event, Emitter<LikeState> emit) async {
    try {
      final r = await repo.getEvents();

      nextPage++;
      totalPages = r.$2;
      emit(state.copyWith(events: r.$1.where((e) => e.isLiked).toList()));
    } catch (e) {
      // emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
      debugPrint("Cached Response");
      final events = repo.getEventsCached();
      emit(state.copyWith(events: events));
    }
  }

  void _handleLikeEvent(LikeLikeEvent event, Emitter<LikeState> emit) async {
    try {
      var events = state.events;
      events[event.index].isLiked = !events[event.index].isLiked;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleCommentEvent(LikeCommentEvent event, Emitter<LikeState> emit) async {
    try {
      var events = state.events;
      events[event.index].myComment =
          events[event.index].myComment.isNotEmpty ? "" : event.comment;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleSavedEvent(LikeSavedEvent event, Emitter<LikeState> emit) async {
    try {
      var events = state.events;
      events[event.index].isSaved = !events[event.index].isSaved;

      await repo.setEventInteraction(events[event.index]);
      emit(state.copyWith(events: events));
    } catch (e) {
      emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleNextEvent(LikeNextEvents event, Emitter<LikeState> emit) async {
    try {
      if (nextPage > totalPages) {
        emit(LikeNoMoreEventsState(events: state.events, loginUser: state.loginUser));
        return;
      }
      var newEvents = await repo.getEvents(page: nextPage);
      // Assuming Total pages might change during fetching next pages
      totalPages = newEvents.$2;
      nextPage++;

      emit(state.copyWith(
          events: state.events..addAll(newEvents.$1.where((e) => e.isLiked).toList())));
    } catch (e) {
      emit(LikeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }
}
