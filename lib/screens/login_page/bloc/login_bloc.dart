import 'package:bloc/bloc.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Repository repo;
  LoginBloc(this.repo) : super(LoginInitial()) {
    on<LoginPressEvent>(_handleLogin);
  }

  void _handleLogin(LoginPressEvent event, Emitter<LoginState> emit) async {
    try {
      final res = await repo.loginUser(event.email, event.password);
      if (res == null) {
        emit(LoginFailed("Bad credentials."));
        return;
      }
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed(e.toString()));
    }
  }
}
