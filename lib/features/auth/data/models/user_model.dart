class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? photo;
  final String semester;
  final String role;
  final int? score;
  final String? fcmToken;
  final String? lastActive;

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
