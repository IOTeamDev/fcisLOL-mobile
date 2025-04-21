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

final class EmailVerifiedLoading extends VerificationState {}

final class EmailVerifiedSuccess extends VerificationState {}

final class EmailVerifiedFailed extends VerificationState {
  final String errMessage;
  EmailVerifiedFailed({required this.errMessage});
}

final class VerificationChangeEyeState extends VerificationState{}

final class VerificationUpdatePasswordLoadingState extends VerificationState{}

final class VerificationUpdatePasswordSuccessState extends VerificationState{}

final class VerificationUpdatePasswordErrorState extends VerificationState{}

final class VerificationGetIDLoadingState extends VerificationState{}

final class VerificationGetIDSuccessState extends VerificationState{}

final class VerificationGetIDErrorState extends VerificationState{}