import 'package:dio/dio.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/data/repos/subject_repo.dart';
import 'package:lol/shared/components/constants.dart';
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

  @override
  Future<Response> addMaterial(
      {required String title,
      String description = '',
      required String link,
      required String type,
      required String semester,
      required String subjectName,
      required String role,
      required AuthorModel author}) async {
    try {
      final response = await DioHelp.postData(
        path: MATERIAL,
        data: {
          'subject': subjectName,
          'title': title,
          'description': description,
          'link': link,
          'type': type,
          'semester': semester,
          'author': {'name': author.authorName, 'photo': author.authorPhoto}
        },
        token: TOKEN,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to add material: $e');
    }
  }
}
