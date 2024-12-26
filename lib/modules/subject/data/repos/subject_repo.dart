import 'package:lol/models/subjects/subject_model.dart';

abstract class SubjectRepo {
  Future<List<MaterialModel>> getMaterials({String? subject});
}
