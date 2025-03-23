import 'package:dio/dio.dart';
import 'package:lol/features/subject/data/models/author_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';

abstract class SubjectRepo {
  Future<List<MaterialModel>> getMaterials({String? subject});
}
