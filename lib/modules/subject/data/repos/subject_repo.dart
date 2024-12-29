import 'package:dio/dio.dart';
import 'package:lol/models/subjects/subject_model.dart';

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
