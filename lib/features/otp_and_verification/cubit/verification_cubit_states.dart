abstract class VerificationCubitStates {}

class VerificationInitState extends VerificationCubitStates {}

class VerificationTimerStartedState extends VerificationCubitStates {
  late final int initialTime;
  VerificationTimerStartedState({required this.initialTime});
}

class VerificationTimerCompleteState extends VerificationCubitStates {}

final class SendVerificationCodeToEmailLoading
    extends VerificationCubitStates {}

final class SendVerificationCodeToEmailSuccess
    extends VerificationCubitStates {}

final class SendVerificationCodeToEmailFailed extends VerificationCubitStates {
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
