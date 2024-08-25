abstract class LoginStates {}

class Initial extends LoginStates {}

class TogglePassword extends LoginStates {}

class Loading extends LoginStates {}

class LoginSuccess extends LoginStates {
  // var Model;
}

class LoginFailed extends LoginStates {}

class RegisterFailed extends LoginStates {
  final String error;
  RegisterFailed(this.error);
}
