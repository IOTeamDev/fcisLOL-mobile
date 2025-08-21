part of 'ticker_cubit.dart';

sealed class TickerState extends Equatable {
  const TickerState({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}

final class TickerInitial extends TickerState {
  const TickerInitial({required super.duration});
}

final class TickerInProgress extends TickerState {
  const TickerInProgress({required super.duration});
}

final class TickerFinished extends TickerState {
  const TickerFinished() : super(duration: 0);
}
