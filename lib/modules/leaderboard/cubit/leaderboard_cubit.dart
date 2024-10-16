// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../layout/home/bloc/main_cubit_states.dart';
// import '../../../models/leaderboard/leaderboard_model.dart';
// import '../../../shared/network/endpoints.dart';
// import '../../../shared/network/remote/dio.dart';

// class LeaderboardCubit extends Cubit<LeaderboardStates> {
//   LeaderboardCubit() : super(LeaderboardInitState());

//   static LeaderboardCubit get(context) => BlocProvider.of(context);

//   List<LeaderboardModel>? leaderboardModel;
//   List<LeaderboardModel>? notAdminleaderboardModel;

//   LeaderboardModel? score4User;

//   void getScore4User(int userId) {
//     score4User = null;
    
//     for (int i = 0; i < leaderboardModel!.length; i++) {
//       print('${leaderboardModel?[i].id}ididididiidididiidididididid');
//       if (leaderboardModel?[i].id == userId) {
//         print(leaderboardModel![i].name.toString() + "dfsgdfggsdg");
//         score4User = leaderboardModel![i];
//         print(score4User!.name.toString() + "dfsgdfggsdg");
//       }
//     }
//     for (int i = 0; i < notAdminleaderboardModel!.length; i++) {
//       if (notAdminleaderboardModel![i].id == userId) {
//         score4User?.userRank = i + 1;
//         print(score4User?.userRank);
//         // emit(GetScore4User());
//       }
//     }
//   }

//   void getLeaderboard() {
//     notAdminleaderboardModel = null;
//     leaderboardModel = null;
//     emit(getLeaderboardLoadingState());
//     DioHelp.getData(path: LEADERBOARD, query: {'semester': 'Two'})
//         .then((value) {
//       leaderboardModel = [];
//       notAdminleaderboardModel = [];
//       value.data.forEach((element) {
//         // exclude the admin
//         leaderboardModel?.add(LeaderboardModel.fromJson(
//             element)); //just to get the score of Admin

//         if (element['role'] != "ADMIN") {
//           notAdminleaderboardModel?.add(LeaderboardModel.fromJson(element));
//         }
// //role
//       });
//       notAdminleaderboardModel!.sort((a, b) => b.score!.compareTo(a.score!));
//       emit(getLeaderboardSuccessState());
//     }).catchError((onError) {
//       print(onError.toString());

//       emit(getLeaderboardErrorState());
//     });
//   }
// }