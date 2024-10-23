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
  }

  void _handleInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
    final r = await repo.getEvents();
    emit(state.copyWith(events: r));
  }
}
