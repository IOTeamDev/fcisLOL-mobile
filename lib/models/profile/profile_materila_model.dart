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
//image

  }


}