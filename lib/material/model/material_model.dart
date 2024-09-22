import 'package:flutter/material.dart';

class MaterialModel {
  int? id;
  String? subject;
  String? link;
  MaterialType? type;
  String? semester;
  // Author? author;
  bool? accepted;

  // MaterialModel({
  //   this.id,
  //   required this.subject,
  //   required this.link,
  //   required this.type,
  //   this.semester,
  //   this.author,
  //   this.accepted = false,
  // });

  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'] ?? '';
    link = json['link'] ?? '';
    type = json['type'] ?? '';
    semester = json['semester'];
    // author = json['author'] != null ? json['author']['name'] : null;
    accepted = json['accepted'];
  }
}

// class Author {
//   String? name;

//   Author({this.name});

//   Author.fromJson(Map<String, dynamic> json) {
//     name = json['name'] ?? '';
//   }
// }

enum MaterialType {
  // ignore: constant_identifier_names
  DOCUMENT,
  // ignore: constant_identifier_names
  YOUTUBE,
}
