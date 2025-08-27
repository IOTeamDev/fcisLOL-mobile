import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  final TickerRepo _tickerRepo;
  static const int _duration = 60;

  TickerCubit(this._tickerRepo) : super(TickerInitial(duration: _duration)) {}

  StreamSubscription<int>? _countDownSubscription;
  int _tickerRepeatedTimes = 1;
  void startTicker() {
    emit(TickerInProgress(duration: _duration * _tickerRepeatedTimes));
    _countDownSubscription =
        _tickerRepo.tick(ticks: _duration * _tickerRepeatedTimes).listen(
      (duration) {
        if (duration <= 0) {
          emit(const TickerFinished());
          resetTicker();
        } else {
          emit(TickerInProgress(duration: duration));
        }
      },
    );
  }

  void resetTicker() {
    _tickerRepeatedTimes++;
    _countDownSubscription?.cancel();
    emit(TickerInitial(duration: _duration * _tickerRepeatedTimes));
  }

  @override
  Future<void> close() {
    _countDownSubscription?.cancel();
    return super.close();
  }
}
