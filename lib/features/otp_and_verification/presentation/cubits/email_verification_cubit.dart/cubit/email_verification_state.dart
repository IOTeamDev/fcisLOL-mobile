part of 'email_verification_cubit.dart';

sealed class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

final class EmailVerificationInitial extends EmailVerificationState {}

final class SendingEmailSuccess extends EmailVerificationState {}

final class SendingEmailFailed extends EmailVerificationState {
  final String errMessage;

  const SendingEmailFailed({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}

final class EmailVerified extends EmailVerificationState {}
