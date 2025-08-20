class AuthStrings {
  static const String emailExpresseion =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  static const String registerSuccessMessage =
      'Your account created successfully. You need to verify your email to continue';

  static const String invalidCredentialsMessage = 'Invalid Email or Password.';
}

final RegExp emailRegExp = RegExp(AuthStrings.emailExpresseion);
