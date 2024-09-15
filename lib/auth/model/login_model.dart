class LoginModel {
  late String message;
  late String token;
  late UserModel user;

  LoginModel.fromJson(Map<String, dynamic> model) {
    message = model["message"];
    token = model["token"];
    user = UserModel.fromJson(model["user"]);
  }
}

class UserModel {
  late String name;
  late String semester;
  late String role;

  UserModel.fromJson(Map<String, dynamic> model) {
    name = model["name"];
    semester = model["semester"];
    role = model["role"];
  }
}
