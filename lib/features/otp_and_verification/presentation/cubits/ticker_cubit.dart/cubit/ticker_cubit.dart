import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lol/features/otp_and_verification/data/repos/ticker_repo/ticker_repo.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  final TickerRepo _tickerRepo;
  static const int _duration = 60;

  TickerCubit(this._tickerRepo) : super(TickerInitial(duration: _duration));

  StreamSubscription<int>? _countDownSubscription;

  void startTicker() {
    emit(TickerInProgress(duration: _duration));
    _countDownSubscription?.cancel();
    _countDownSubscription = _tickerRepo.tick(ticks: _duration).listen(
      (duration) {
        if (duration <= 0) {
          emit(const TickerFinished());
        } else {
          emit(TickerInProgress(duration: duration));
        }
      },
    );
  }

  void resetTicker() {
    _countDownSubscription?.cancel();
    emit(const TickerInitial(duration: _duration));
  }

  @override
  Future<void> close() {
    _countDownSubscription?.cancel();
    return super.close();
  }
}
