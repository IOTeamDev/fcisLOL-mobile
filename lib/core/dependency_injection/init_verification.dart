import 'package:lol/core/dependency_injection/service_locator.dart';
import 'package:lol/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:lol/features/otp_and_verification/data/data_sources/ticker_data_source.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo_impl.dart';
import 'package:lol/features/otp_and_verification/data/repos/verification_repo/verification_repo.dart';
import 'package:lol/features/otp_and_verification/data/repos/verification_repo/verification_repo_impl.dart';

void initVerification() {
  //Data Sources
  getIt.registerLazySingleton<TickerDataSource>(
    () => TickerDataSourceImpl(),
  );

  //Repos
  getIt.registerLazySingleton<VerificationRepo>(
    () => VerificationRepoImpl(getIt<FirebaseAuthDataSource>()),
  );

  getIt.registerLazySingleton<TickerRepo>(
    () => TickerRepoImpl(tickerDataSource: getIt<TickerDataSource>()),
  );
}
