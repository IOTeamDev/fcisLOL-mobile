import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/features/auth/data/data_sources/auth_api_data_source.dart';
import 'package:lol/features/auth/data/repos/auth_repo.dart';
import 'package:lol/features/auth/data/repos/auth_repo_impl.dart';

void initAuth() {
  //Data Sources

  getIt.registerLazySingleton<AuthApiDataSource>(() => AuthApiDataSourceImpl());

  // Repos
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authApiDataSource: getIt<AuthApiDataSource>()),
  );
}
