import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/modules/leaderboard/cubit/leaderboard_states.dart';

import '../../../layout/home/bloc/main_cubit_states.dart';
import '../../../models/leaderboard/leaderboard_model.dart';
import '../../../shared/network/endpoints.dart';
import '../../../shared/network/remote/dio.dart';

class LeaderboardCubit extends Cubit<LeaderboardStates>{
  LeaderboardCubit() : super(LeaderboardInitState());

  static LeaderboardCubit get(context) => BlocProvider.of(context);

  List<LeaderboardModel>? leaderboardModel;
  void getLeaderboard()
  {
    emit(getLeaderboardLoadingState());
    DioHelp.getData(path: LEADERBOARD, query: {'semester':'One'}).then((value)
    {
      leaderboardModel = [];
      value.data.forEach((element){
        leaderboardModel!.add(LeaderboardModel.fromJson(element));
      });
      leaderboardModel!.sort((a, b) => b.score!.compareTo(a.score!));
      emit(getLeaderboardSuccessState());
    });
  }
}