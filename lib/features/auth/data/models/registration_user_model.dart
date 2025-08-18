class RegistrationUserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String semester;
  final String? photo;
  final String? fcmToken;

  RegistrationUserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.semester,
    required this.phone,
    this.photo,
    this.fcmToken,
  });
}
