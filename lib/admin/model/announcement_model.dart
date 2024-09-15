class AnnouncementModel {
  late int id;
  late String title;
  late String content;
  late String thumbnail;
  late String type;
  late String semester;

  AnnouncementModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    type = json['type'];
    semester = json['semester'];
  }
}
