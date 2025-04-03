abstract class VerificationCubitStates{}

class VerificationInitState extends VerificationCubitStates{}

class VerificationTimerStartedState extends VerificationCubitStates{
  late final int initialTime;
  VerificationTimerStartedState({required this.initialTime});
}

class VerificationTimerCompleteState extends VerificationCubitStates{}
