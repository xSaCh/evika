part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginFailed extends LoginState {
  final String msg;

  LoginFailed(this.msg);
}

final class LoginSuccess extends LoginState {}
