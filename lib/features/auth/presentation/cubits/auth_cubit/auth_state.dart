part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailed extends AuthState {
  final String errMessage;

  LoginFailed({required this.errMessage});
}

final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {
  final String token;
  final String userEmail;
  final String message;

  RegisterSuccess(
      {required this.token, required this.userEmail, required this.message});
}

final class RegisterFailed extends AuthState {
  final String errMessage;

  RegisterFailed({required this.errMessage});
}

final class SelectedSemesterChanged extends AuthState {
  final String semester;

  SelectedSemesterChanged({required this.semester});
}

final class UploadImageLoading extends AuthState {}

final class UploadImageSuccess extends AuthState {}

final class UploadImageFailed extends AuthState {}
