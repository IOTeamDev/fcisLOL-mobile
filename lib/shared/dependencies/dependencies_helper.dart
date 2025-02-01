import 'package:get_it/get_it.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/subject/data/repos/subject_repo.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<SubjectRepoImp>(SubjectRepoImp());
}
