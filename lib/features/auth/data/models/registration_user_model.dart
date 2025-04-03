class RegistrationUserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String semester;
  final String? photo;

  RegistrationUserModel({
    required this.semester,
    required this.name,
    required this.email,
    required this.password,
    this.photo,
    required this.phone,
  });
}
