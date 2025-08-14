import 'package:get_it/get_it.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:lol/features/subject/data/repos/subject_repo.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/view_model/add_material_cubit/add_material_cubit.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<SubjectRepoImp>(SubjectRepoImp());

  getIt.registerSingleton<AuthCubit>(AuthCubit());
}
