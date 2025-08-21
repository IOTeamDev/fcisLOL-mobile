abstract class TickerDataSource {
  Stream<int> tick({required int ticks});
}

class TickerDataSourceImpl implements TickerDataSource {
  @override
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => ticks - count - 1,
    ).take(ticks);
  }
}
