class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String semester;
  final String? photo;
  final String? fcmToken;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.semester,
    required this.phone,
    this.photo,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "photo": photo,
      "semester": semester,
      "fcmToken": fcmToken,
    };
  }
}
