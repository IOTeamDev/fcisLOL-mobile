part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class TogglePassword extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailed extends AuthState {
  final String errMessage;

  LoginFailed({required this.errMessage});
}

final class LogoutLoading extends AuthState {}

final class LogoutSuccess extends AuthState {}

final class LogoutFailed extends AuthState {
  final String errMessage;

  LogoutFailed({required this.errMessage});
}

final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {
  final String token;

  RegisterSuccess({required this.token});
}

final class RegisterFailed extends AuthState {
  final String errMessage;

  RegisterFailed({required this.errMessage});
}

final class UploadImageLoading extends AuthState {}

final class UploadImageSuccess extends AuthState {}

final class UploadImageFailure extends AuthState {}

final class SendVerificationCodeLoading extends AuthState {}

final class SendVerificationCodeSuccess extends AuthState {}

final class SendVerificationCodeFailed extends AuthState {
  final String errMessage;
  SendVerificationCodeFailed({required this.errMessage});
}

// final class EmailVerifiedLoading extends AuthState {}

// final class BuyerVerifiedSuccess extends AuthState {}

// final class SellerVerifiedSuccess extends AuthState {}

// final class EmailVerifiedFailed extends AuthState {
//   final String errMessage;
//   EmailVerifiedFailed({required this.errMessage});
// }
