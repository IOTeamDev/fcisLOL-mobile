class AnnouncementModel {
  late int id;
  late String title;
  late String content;
  late dynamic dueDate;
  late String type;
  late String semester;

  AnnouncementModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    dueDate = json['due_date'];
    type = json['type'];
    semester = json['semester'];
  }
}
