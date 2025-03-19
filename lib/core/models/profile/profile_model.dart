import 'package:lol/core/models/profile/profile_materila_model.dart';

class ProfileModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  late int score;
  late String phone;
  late String photo;
  late int id;
  late List<ProfileMaterilaModel> materials = [];

  ProfileModel.fromJson(Map model) {
    name = model['name'];
    email = model['email'];
    semester = model['semester'];
    role = model['role'];
    phone = model['phone'] ?? "";
    score = model['score'];
    id = model['id'];
    photo = model['photo'];

    model['material'].forEach((element) {
      materials.add(ProfileMaterilaModel.fromJson(element));
    });
  }
}
