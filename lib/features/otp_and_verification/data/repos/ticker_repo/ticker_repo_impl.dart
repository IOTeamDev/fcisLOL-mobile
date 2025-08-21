import 'package:lol/features/otp_and_verification/data/data_sources/ticker_data_source.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';

class TickerRepoImpl extends TickerRepo {
  final TickerDataSource _tickerDataSource;
  TickerRepoImpl({required TickerDataSource tickerDataSource})
      : _tickerDataSource = tickerDataSource;
  @override
  Stream<int> tick({required int ticks}) {
    return _tickerDataSource.tick(ticks: ticks);
  }
}
