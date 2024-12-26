import 'package:dio/dio.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/data/repos/subject_repo.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';

class SubjectRepoImp implements SubjectRepo {
  @override
  Future<List<MaterialModel>> getMaterials({String? subject}) async {
    try {
      List<MaterialModel> materials = [];

      final response = await DioHelp.getData(
        path: MATERIAL,
        query: {'subject': subject, 'accepted': true},
      );
      for (var material in response.data) {
        materials.add(MaterialModel.fromJson(material));
      }
      return materials;
    } on DioException catch (e) {
      throw Exception('Failed to fetch materials: $e');
    }
  }
}
