import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/features/auth/data/data_sources/auth_api_data_source.dart';
import 'package:lol/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:lol/features/auth/domain/repos/auth_repo.dart';
import 'package:lol/features/auth/data/repos/auth_repo_impl.dart';
import 'package:lol/features/auth/domain/use_cases/logout_use_case.dart';

void initAuth() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Data Sources

  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AuthApiDataSource>(() => AuthApiDataSourceImpl());

  // Repos
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      authApiDataSource: getIt<AuthApiDataSource>(),
      firebaseAuthDataSource: getIt<FirebaseAuthDataSource>(),
      firebaseMessaging: getIt<FirebaseMessaging>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepo>()),
  );
}
