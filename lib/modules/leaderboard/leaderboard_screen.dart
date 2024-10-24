import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/main.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';

class LeaderboardScreen extends StatelessWidget {
  final String semester;
  const LeaderboardScreen({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()..getProfileInfo()..getLeaderboard(semester)),
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
          double width = screenWidth(context);
          double height = screenHeight(context);
          return Scaffold(
          key: scaffoldKey,
          body: Container(

            margin: const EdgeInsetsDirectional.only(top: 90),
            width: double.infinity,
            child: ConditionalBuilder(
              condition:
              MainCubit.get(context).notAdminLeaderboardModel !=
              null &&
              state is! GetLeaderboardLoadingState,
              builder: (context) => Column(
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
                          style: TextStyle(fontSize: width / 11, ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height/30,),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            if(MainCubit.get(context).notAdminLeaderboardModel![1].name != null)
                            ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.5),child: Text(MainCubit.get(context).notAdminLeaderboardModel![1].name.toString(), style: TextStyle(fontSize: width/19),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center,)),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: HexColor('#374C92'),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              ),
                              height: 170,
                              width: width/3.2,

                              child: MainCubit.get(context).notAdminLeaderboardModel![1].name != null? Column(
                                children: [
                                  Container(height: 35, width: 35, child: Center(child: Text('2', style: TextStyle(color: Colors.black, fontSize: width/20),)), decoration: BoxDecoration(color: HexColor('#C0C0C0'), borderRadius: BorderRadius.circular(10)),),
                                  SizedBox(height: 10,),
                                  Text('${MainCubit.get(context).notAdminLeaderboardModel![1].score??'-'} pts', style: TextStyle(fontSize: width/17),),
                                ],
                              ): Container(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.5),child: Text(MainCubit.get(context).notAdminLeaderboardModel![0].name.toString(), style: TextStyle(fontSize: width/19),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center,)),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: HexColor('#4764C5'),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              ),
                              height: 230,
                              width: width/3.2,
                              child: Column(
                                children: [
                                  Container(height: 40, width: 40,child: Center(child: Text('1', style: TextStyle(color: Colors.black, fontSize: width/18),)), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),),
                                  SizedBox(height: 10,),
                                  Text('${MainCubit.get(context).notAdminLeaderboardModel![0].score} pts',  style: TextStyle(fontSize: width/15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            if(MainCubit.get(context).notAdminLeaderboardModel![2].name != null)
                            ConstrainedBox(constraints: BoxConstraints(maxWidth: width/3.5),child: Text(MainCubit.get(context).notAdminLeaderboardModel![2].name.toString(), style: TextStyle(fontSize: width/19),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center,)),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: HexColor('#374C92'),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              ),
                              height: 130,
                              width: width/3.2,
                              child: MainCubit.get(context).notAdminLeaderboardModel![1].name != null? Column(
                                children: [
                                  Container(height: 30, width: 30, decoration: BoxDecoration(color: HexColor('#CD7F32'), borderRadius: BorderRadius.circular(10)), child: Center(child: Text('3', style: TextStyle(color: Colors.black, fontSize: width/20),)),),
                                  SizedBox(height: 10,),
                                  Text('${MainCubit.get(context).notAdminLeaderboardModel![2].score} pts', style: TextStyle(fontSize: width/19),),
                                ],
                              ): Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0,thickness: 2, color: isDark? Colors.white: Colors.black,),
                  Expanded(
                    child:  ListView.separated(
                          itemCount: MainCubit.get(context).notAdminLeaderboardModel!.length - 3,
                          itemBuilder: (context, index) {
                            return buildList(
                              context,
                                (index + 4),
                                MainCubit.get(context)
                                    .notAdminLeaderboardModel![index + 3]
                                    .name,
                                MainCubit.get(context)
                                    .notAdminLeaderboardModel![index + 3]
                                    .score);
                          },
                          separatorBuilder: (context, state) => Padding(
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 15.0, horizontal: 15),
                            child: divider(),
                          ),
                        )
                    ),
                ],
              ),
              fallback: (context) {
                if(state is GetLeaderboardLoadingState)
                return Center(child: CircularProgressIndicator(),);
                else
                  return Center(child: Text('You LeaderBorad Yet!!!'),);
              },
            ),
          ),
        );
        },
      ),
    );
  }

  Widget buildList(context, index, name, score) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey))),
              child: Text(index.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            SizedBox(
              width: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth(context)/1.2),
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey))),
              child: Text(
                score.toString(),
                style: TextStyle(
                  color: Colors.white,
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
