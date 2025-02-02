import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/navigation.dart';

class LeaderboardScreen extends StatelessWidget {
  final String semester;
  const LeaderboardScreen({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()
              ..getProfileInfo()
              ..getLeaderboard(semester)),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          // if (TOKEN == null)
          // {
          //     MainCubit.get(context).getLeaderboard(SelectedSemester);
          // }
          // else
          // {
          //   if(state is GetProfileSuccess)
          //   {
          //       MainCubit.get(context).getLeaderboard(MainCubit.get(context).profileModel!.semester);
          //   }
          // }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsDirectional.only(top: 20, bottom: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: backButton(context),
                          ),
                          Center(
                            child: Text(
                              'Leaderboard',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: AppQueries.screenHeight(context) / 1.1),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 30),
                          child: ConditionalBuilder(
                            condition: MainCubit.get(context)
                                        .notAdminLeaderboardModel !=
                                    null &&
                                state is! GetLeaderboardLoadingState &&
                                (MainCubit.get(context)
                                            .notAdminLeaderboardModel
                                            ?.length ??
                                        0) >=
                                    3,
                            builder: (context) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: AppQueries.screenHeight(context) / 30,
                                ),
                                //Top 3 Contributors Stages
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => navigate(
                                              context,
                                              OtherProfile(
                                                id: MainCubit.get(context)
                                                    .notAdminLeaderboardModel![
                                                        1]
                                                    .id,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      MainCubit.get(context)
                                                          .notAdminLeaderboardModel![
                                                              1]
                                                          .photo!),
                                                  radius: AppQueries.screenWidth(context) / 12,
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: AppQueries.screenWidth(context) / 3.5),
                                                    child: Text(
                                                      MainCubit.get(context)
                                                          .notAdminLeaderboardModel![
                                                              1]
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: AppQueries.screenWidth(context) / 19),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsetsDirectional
                                                      .symmetric(vertical: 20),
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#374C92'),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15)),
                                                  ),
                                                  height: AppQueries.screenHeight(context) / 4,
                                                  width: AppQueries.screenWidth(context) / 3.2,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            color: HexColor(
                                                                '#C0C0C0'),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                            child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                              AppQueries.screenWidth(context) / 20),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${MainCubit.get(context).notAdminLeaderboardModel![1].score} pts',
                                                        style: TextStyle(
                                                            fontSize:
                                                            AppQueries.screenWidth(context) / 17),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => navigate(
                                          context,
                                          OtherProfile(
                                            id: MainCubit.get(context)
                                                .notAdminLeaderboardModel![0]
                                                .id,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  MainCubit.get(context)
                                                      .notAdminLeaderboardModel![
                                                          0]
                                                      .photo!),
                                              radius: AppQueries.screenWidth(context) / 11,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: AppQueries.screenWidth(context) / 3.5),
                                                child: Text(
                                                  MainCubit.get(context)
                                                      .notAdminLeaderboardModel![
                                                          0]
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: AppQueries.screenWidth(context) / 19),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(vertical: 20),
                                              decoration: BoxDecoration(
                                                color: HexColor('#4764C5'),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                              ),
                                              height: AppQueries.screenHeight(context) / 3.2,
                                              width: AppQueries.screenWidth(context) / 3.2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                        child: Text(
                                                      '1',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: AppQueries.screenWidth(context) / 18),
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      '${MainCubit.get(context).notAdminLeaderboardModel![0].score} pts',
                                                      style: TextStyle(
                                                          fontSize:
                                                          AppQueries.screenWidth(context) / 15)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => navigate(
                                          context,
                                          OtherProfile(
                                            id: MainCubit.get(context)
                                                .notAdminLeaderboardModel![2]
                                                .id,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  MainCubit.get(context)
                                                      .notAdminLeaderboardModel![
                                                          2]
                                                      .photo!),
                                              radius: AppQueries.screenWidth(context) / 13,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: AppQueries.screenWidth(context) / 3.5),
                                                child: Text(
                                                  MainCubit.get(context)
                                                      .notAdminLeaderboardModel![
                                                          2]
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: AppQueries.screenWidth(context) / 19),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(vertical: 20),
                                              decoration: BoxDecoration(
                                                color: HexColor('#374C92'),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                              ),
                                              height: AppQueries.screenHeight(context) / 5,
                                              width: AppQueries.screenWidth(context) / 3.2,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            HexColor('#CD7F32'),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                        child: Text(
                                                      '3',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: AppQueries.screenWidth(context) / 20),
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${MainCubit.get(context).notAdminLeaderboardModel![2].score} pts',
                                                    style: TextStyle(
                                                        fontSize: AppQueries.screenWidth(context) / 19),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 2,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                //Other Contributors
                                ConditionalBuilder(
                                  condition: MainCubit.get(context)
                                          .notAdminLeaderboardModel!
                                          .length >
                                      4,
                                  builder: (context) => ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: MainCubit.get(context)
                                                    .notAdminLeaderboardModel
                                                    ?.length !=
                                                null &&
                                            MainCubit.get(context)
                                                    .notAdminLeaderboardModel!
                                                    .length >=
                                                4
                                        ? (MainCubit.get(context)
                                                    .notAdminLeaderboardModel!
                                                    .length >=
                                                10
                                            ? 7
                                            : MainCubit.get(context)
                                                    .notAdminLeaderboardModel!
                                                    .length -
                                                3)
                                        : 0,
                                    itemBuilder: (context, index) {
                                      return buildList(
                                          context,
                                          (index + 4),
                                          MainCubit.get(context)
                                              .notAdminLeaderboardModel![
                                                  index + 3]
                                              .name,
                                          MainCubit.get(context)
                                              .notAdminLeaderboardModel![
                                                  index + 3]
                                              .score,
                                          MainCubit.get(context)
                                              .notAdminLeaderboardModel![
                                                  index + 3]
                                              .id);
                                    },
                                    separatorBuilder: (context, state) =>
                                        Padding(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 15.0, horizontal: 15),
                                      child: divider(),
                                    ),
                                  ),
                                  fallback: (context) => SizedBox(
                                      height: AppQueries.screenHeight(context) / 3,
                                      child: Center(
                                        child: Text(
                                          'No more Users!!!',
                                          style:
                                              TextStyle(fontSize: AppQueries.screenWidth(context) / 12),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            fallback: (context) {
                              if (state is GetLeaderboardLoadingState) {
                                return SizedBox(
                                    height: AppQueries.screenHeight(context) / 1.3,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                              return SizedBox(
                                  height: AppQueries.screenHeight(context) / 1.3,
                                  child: Center(
                                    child: Text(
                                      'No Leaderboard Yet!!!',
                                      style: TextStyle(fontSize: AppQueries.screenWidth(context) / 12),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildList(context, index, name, score, id) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey))),
              child: Text(index.toString(), style: TextStyle(fontSize: 20)),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: AppQueries.screenWidth(context) / 1.2),
                child: GestureDetector(
                  onTap: () => navigate(
                    context,
                    OtherProfile(
                      id: id,
                    ),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 20),
                    // maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey))),
              child: Text(
                score.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
