part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class TogglePassword extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;

  LoginSuccess({required this.token});
}

class LoginFailed extends AuthState {
  final String errMessage;

  LoginFailed({required this.errMessage});
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String token;

  RegisterSuccess({required this.token});
}

class RegisterFailed extends AuthState {
  final String errMessage;

  RegisterFailed({required this.errMessage});
}
