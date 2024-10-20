class AnnouncementModel {
  late int id;
  late String title;
  late String content;
  dynamic dueDate;
  late String type;
  late String semester;
  late String image;

  AnnouncementModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    dueDate = json['due_date']??'No Due Date';
    type = json['type'];
    semester = json['semester'];
    image = json['image'];
  }
}
