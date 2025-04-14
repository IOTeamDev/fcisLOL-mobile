part of 'verification_cubit.dart';

@immutable
sealed class VerificationState {}

final class VerificationInitial extends VerificationState {}

class VerificationTimerStartedState extends VerificationState {
  late final int initialTime;
  VerificationTimerStartedState({required this.initialTime});
}

class VerificationTimerCompleteState extends VerificationState {}

final class SendVerificationCodeToEmailLoading extends VerificationState {}

final class SendVerificationCodeToEmailSuccess extends VerificationState {}

final class SendVerificationCodeToEmailFailed extends VerificationState {
  final String errMessage;
  SendVerificationCodeToEmailFailed({required this.errMessage});
}

// final class EmailVerifiedLoading extends AuthState {}

// final class BuyerVerifiedSuccess extends AuthState {}

// final class SellerVerifiedSuccess extends AuthState {}

// final class EmailVerifiedFailed extends AuthState {
//   final String errMessage;
//   EmailVerifiedFailed({required this.errMessage});
// }
