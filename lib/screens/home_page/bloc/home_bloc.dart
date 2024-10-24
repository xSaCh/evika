import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/data/util.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Repository repo;
  int nextPage;
  int totalPages;

  int nextSearchPage;
  int totalSearchPages;
  String searchQuery;
  List<Event> fetchedEvents;

  HomeBloc(this.repo)
      : nextPage = 1,
        nextSearchPage = 1,
        totalPages = 0,
        totalSearchPages = 0,
        searchQuery = "",
        fetchedEvents = [],
        super(HomeState.empty()) {
    on<HomeInitialEvent>(_handleInitialEvent);
    on<HomeSearchEvent>(_handleSearchEvent);
    on<HomeLikeEvent>(_handleLikeEvent);
    on<HomeCommentEvent>(_handleCommentEvent);
    on<HomeSavedEvent>(_handleSavedEvent);
    on<HomeNextEvents>(_handleNextEvent);
    on<HomeFilterEvent>(_handleFilterEvent);
  }

  void _handleInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
    try {
      final r = await repo.getEvents();
      nextPage++;
      totalPages = r.$2;
      fetchedEvents = List.from(r.$1);

      for (var e in r.$1) {
        state.uniqueCategories
            .addAll(e.eventCategory.map((e) => getCategoryNameFromId(e)));
      }

      emit(state.copyWith(events: fetchedEvents));
    } catch (e) {
      // emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
      debugPrint("Cached Response");
      final events = repo.getEventsCached();
      emit(HomeFailureState(events: events, errorMsg: "Showing cached events"));
    }
  }

  void _handleSearchEvent(HomeSearchEvent event, Emitter<HomeState> emit) async {
    try {
      // Sent previously fetched home events if no search query
      nextSearchPage = 1;
      searchQuery = event.query;

      if (searchQuery.isEmpty) {
        emit(state.copyWith(events: fetchedEvents));
        return;
      }

      final r = await repo.searchEvents(searchQuery, page: nextSearchPage);
      nextSearchPage++;
      totalSearchPages = r.$2;

      for (var e in r.$1) {
        state.uniqueCategories
            .addAll(e.eventCategory.map((e) => getCategoryNameFromId(e)));
      }

      emit(state.copyWith(events: r.$1));
    } catch (e) {
      emit(HomeFailureState(
          events: state.events, errorMsg: "Failed to get search results"));
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
      // Get Next Events from search if query is not empty
      if (searchQuery.isNotEmpty) {
        if (nextSearchPage > totalSearchPages) {
          emit(HomeNoMoreEventsState(events: state.events, loginUser: state.loginUser));
          return;
        }
        var newEvents = await repo.searchEvents(searchQuery, page: nextSearchPage);
        totalSearchPages = newEvents.$2;
        nextSearchPage++;

        for (var e in newEvents.$1) {
          state.uniqueCategories
              .addAll(e.eventCategory.map((e) => getCategoryNameFromId(e)));
        }

        emit(state.copyWith(events: state.events..addAll(newEvents.$1)));
        return;
      }

      // Get Next Events
      if (nextPage > totalPages) {
        emit(HomeNoMoreEventsState(events: state.events, loginUser: state.loginUser));
        return;
      }
      var newEvents = await repo.getEvents(page: nextPage);
      fetchedEvents.addAll(newEvents.$1);

      // Assuming Total pages might change during fetching next pages
      totalPages = newEvents.$2;
      nextPage++;

      for (var e in newEvents.$1) {
        state.uniqueCategories
            .addAll(e.eventCategory.map((e) => getCategoryNameFromId(e)));
      }
      emit(state.copyWith(events: state.events..addAll(newEvents.$1)));
    } catch (e) {
      emit(HomeFailureState(events: state.events, errorMsg: e.toString()));
    }
  }

  void _handleFilterEvent(HomeFilterEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedCategories: event.selectedCategories));
  }
}
