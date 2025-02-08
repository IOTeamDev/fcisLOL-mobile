// class RequestsModel {
//   //subject name (back)
//   int? id;
//   String? link;
//   String? type;
//   String? title;
//   String? subject;
//   String? description;
//   Author? author;

//   RequestsModel.fromJson(Map<String, dynamic> json) {
    
//     id = json['id'];
//     link = json['link'];
//     type = json['type'];
//     title = json['title'];
//     description = json['description'];
//     subject = json['subject'];
//     author = json['author'] != null ? Author.fromJson(json['author']) : null;
//   }

// }

// class Author {
//   String? name;
//   String? photo;

//   Author.fromJson(Map<String, dynamic> json) {
//     name = json['name']??'';
//     photo = json['photo']??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s';
//   }
// }