import 'package:flutter/material.dart';

class MaterialModel {
  String? title;
  String? description;
  int? id;
  String? subject;
  String? link;
  String? type;
  String? semester;
  bool? accepted;

  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    subject = json['subject'] ?? 'Unknown Subject';
    link = json['link'] ?? '';
    type = json['type'] ?? 'Unknown Type';
    semester = json['semester'] ?? 'Unknown Semester';
    accepted = json['accepted'] ?? false;
    title = json['title'] ?? 'No Title';
    description = json['description'] ?? 'No Description';
  }
}
