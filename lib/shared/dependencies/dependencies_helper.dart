import 'package:get_it/get_it.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/subject/data/repos/subject_repo.dart';
import 'package:lol/modules/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/modules/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:lol/modules/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<SubjectRepoImp>(SubjectRepoImp());
}
