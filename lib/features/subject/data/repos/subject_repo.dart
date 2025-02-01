import 'package:dio/dio.dart';
import 'package:lol/features/subject/data/models/author_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';

abstract class SubjectRepo {
  Future<List<MaterialModel>> getMaterials({String? subject});

  Future<Response> addMaterial(
      {required String title,
      String description = '',
      required String link,
      required String type,
      required String semester,
      required String subjectName,
      required String role,
      required AuthorModel author});
}
