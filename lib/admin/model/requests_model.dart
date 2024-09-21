class RequestsModel {
  int? id;
  String? link;
  String? type;
  String? subject;
  Author? author;

  RequestsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    type = json['type'];
    subject = json['subject']??'';
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
  }

}

class Author {
  String? name;
  String? photo;

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name']??'';
    photo = json['photo']??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s';
  }
}