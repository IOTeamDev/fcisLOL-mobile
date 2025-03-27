class PreviousExamModel{
  late int id;
  late String title;
  late String link;
  late String type;
  late String subject;

  PreviousExamModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    link = json['link'];
    type = json['type'];
    subject = json['subject'];
  }
}