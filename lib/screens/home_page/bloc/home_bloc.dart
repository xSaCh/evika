import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Repository repo;
  HomeBloc(this.repo) : super(HomeState.empty()) {
    on<HomeInitialEvent>(_handleInitialEvent);
    on<HomeLikeEvent>(_handleLikeEvent);
    on<HomeCommentEvent>(_handleCommentEvent);
    on<HomeSavedEvent>(_handleSavedEvent);
  }

  void _handleInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
    final r = await repo.getEvents();
    emit(state.copyWith(events: r));
  }

  void _handleLikeEvent(HomeLikeEvent event, Emitter<HomeState> emit) async {
    var events = state.events;
    events[event.index].isLiked = !events[event.index].isLiked;
    emit(state.copyWith(events: events));
  }

  void _handleCommentEvent(HomeCommentEvent event, Emitter<HomeState> emit) async {
    var events = state.events;
    events[event.index].myComment = event.comment;
    emit(state.copyWith(events: events));
  }

  void _handleSavedEvent(HomeSavedEvent event, Emitter<HomeState> emit) async {
    var events = state.events;
    events[event.index].isSaved = !events[event.index].isSaved;
    emit(state.copyWith(events: events));
  }
}
