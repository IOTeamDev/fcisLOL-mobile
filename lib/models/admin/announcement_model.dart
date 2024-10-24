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
    image = json['image']??"https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f";
  }
}
