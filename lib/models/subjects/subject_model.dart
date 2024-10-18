import 'package:flutter/material.dart';
import 'package:googleapis/shared.dart';

class MaterialModel {
  String? title;
  String? description;
  int? id;
  String? subject;
  String? link;
  String? type;
  AuthorModel? author;


  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    subject = json['subject'] ?? 'Unknown Subject';
    link = json['link'] ?? '';
    type = json['type'] ?? 'Unknown Type';
    title = json['title'] ?? 'No Title';
    description = json['description'] ?? 'No Description';
    author = AuthorModel.fromJson(json['author']);
  }
}

class AuthorModel{

  String? authorName;
  String? authorPhoto;

  AuthorModel.fromJson(Map<String, dynamic> json)
  {
    authorName = json['name'];
    authorName = json['photo'];
  }

}
