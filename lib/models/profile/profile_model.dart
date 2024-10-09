import 'package:lol/models/profile/profile_materila_model.dart';
import 'package:lol/models/subjects/subject_model.dart';

class ProfileModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  String? phone;
  late String photo;
  late int id;
 late  List<ProfileMaterilaModel> materials=[];

  ProfileModel.fromJson(Map model) {
    name = model['name'];
    email = model['email'];
    semester = model['semester'];
    role = model['role'];
    phone = model['phone'] ?? "";
    id = model['id'];
    photo = model['photo'] ??
        "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";
    model['material'].forEach((element) {
    materials.add( ProfileMaterilaModel.fromJson(element)) ;
    });
  }
}
