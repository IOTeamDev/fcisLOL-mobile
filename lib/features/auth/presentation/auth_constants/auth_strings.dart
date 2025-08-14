class AuthStrings {
  static const String emailExpresseion =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
}

final RegExp emailRegExp = RegExp(AuthStrings.emailExpresseion);
