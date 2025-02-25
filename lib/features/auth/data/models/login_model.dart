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

class UserModel {
  int? id;
  String name;
  String email;
  String? photo;
  String semester;
  String role;
  int? score;
  String? fcmToken;
  String? lastActive;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.photo,
      required this.semester,
      required this.role,
      required this.score,
      this.fcmToken,
      this.lastActive});

  factory UserModel.fromJson(Map<String, dynamic> model) {
    return UserModel(
      id: model["id"],
      name: model["name"],
      email: model["email"],
      photo: model["photo"],
      semester: model["semester"],
      role: model["role"],
      fcmToken: model["fcmToken"],
      score: model["score"],
      lastActive: model["lastActive"],
    );
  }
}
