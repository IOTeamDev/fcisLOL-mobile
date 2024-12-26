import 'package:lol/models/profile/profile_materila_model.dart';
import 'package:lol/models/subjects/subject_model.dart';

class ProfileModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  String? phone;
  String? photo;
  late int id;
  late List<ProfileMaterilaModel> materials = [];

  ProfileModel.fromJson(Map model) {
    name = model['name'];
    email = model['email'];
    semester = model['semester'];
    role = model['role'];
    phone = model['phone'] ?? "";
    id = model['id'];
    photo = model['photo'];

    model['material'].forEach((element) {
      materials.add(ProfileMaterilaModel.fromJson(element));
    });
  }
}
