import 'package:lol/features/auth/data/models/user_model.dart';

class LoginModel {
  String message;
  String token;
  UserModel user;
  LoginModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> model) {
    return LoginModel(
      message: model["message"],
      token: model["token"],
      user: UserModel.fromJson(model["user"]),
    );
  }
}
