import 'package:get_it/get_it.dart';
import 'package:lol/modules/subject/data/repos/subject_repo.dart';
import 'package:lol/modules/subject/data/repos/subject_repo_imp.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<SubjectRepoImp>(SubjectRepoImp());
}
