import 'package:flutter/material.dart';

class MaterialModel {
  int? id;
  String? subject;
  String? link;
  String? type;
  String? semester;
  Author? author;
  bool? accepted;

  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'] ?? '';
    link = json['link'] ?? '';
    type = json['type'] ?? '';
    semester = json['semester'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    accepted = json['accepted'];
  }
}

class Author {
  String? name;
  String? photo;

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    photo = json['photo'] ?? '';
  }
}
