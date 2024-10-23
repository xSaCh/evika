part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginPressEvent extends LoginEvent {
  final String email;
  final String password;

  LoginPressEvent(this.email, this.password);
}
