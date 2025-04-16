import 'package:lol/core/models/profile/profile_materila_model.dart';

class ProfileModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  late int score;
  late String phone;
  String? photo;
  late int id;
  late bool isVerified;
  late List<ProfileMaterilaModel> materials = [];

  ProfileModel.fromJson(Map model) {
    name = model['name'];
    email = model['email'];
    semester = model['semester'];
    role = model['role'];
    phone = model['phone'] ?? '';
    score = model['score'];
    id = model['id'];
    isVerified = model['isVerified'];
    photo = model['photo'] ??
        'd6p6og4VRY6kKV4io3KAOB:APA91bHzfvSOIpS-EPhPOguP0vaML_PkFezg7je4F6qTJcq-ybScNyxItyOK8kGEZWUQi6tK0uXsMx-RTIq77C-lM9Yh5--DqRsbMNme4nOksb-TYc_ZNTo2uyUD7x6ACZPji5FZ8BN4';

    model['material'].forEach((element) {
      materials.add(ProfileMaterilaModel.fromJson(element));
    });
  }
}

class ProfileMaterilaModel {
  int? id;
  String? subject;
  String? link;
  String? type;
  int? authorId;
  bool? accepted;
  String? semester;
  String? title;
  String? description;

  ProfileMaterilaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    link = json['link'];
    type = json['type'];
    authorId = json['authorId'];
    accepted = json['accepted'];
    semester = json['semester'];
    title = json['title'];
    description = json['description'];
  }
}
