import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/modules/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:lol/modules/leaderboard/cubit/leaderboard_states.dart';
import 'package:lol/shared/components/components.dart';

class LeaderboardScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var scafooldKey = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) => LeaderboardCubit()..getLeaderboard(),
      child: BlocConsumer<LeaderboardCubit, LeaderboardStates>(
        listener: (context, state){},
        builder:(context, state) => Scaffold(
          key: scafooldKey,
          backgroundColor: Colors.black,
          drawer: drawerBuilder(context),
          body: Stack(
            children: [
              backgroundEffects(),
              Container(
                margin: const EdgeInsetsDirectional.only(top: 50),
                width: double.infinity,
                child: Column(
                  children: [
                    backButton(context),
                    adminTopTitleWithDrawerButton(title: 'Leaderboard', hasDrawer: true, size: 35, ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0, horizontal: 20),
                      child: divider(),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                            child: Text('Rank', style: TextStyle(color: Colors.grey, fontSize: 20)),
                          ),
                          SizedBox(width: 20,),
                          Text('Name', style: TextStyle(color: Colors.grey, fontSize: 20),),
                          Spacer(),
                          Container(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey))),
                              child: Text('Score', style: TextStyle(color: Colors.grey, fontSize: 20,),)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0, horizontal: 20),
                      child: divider(),
                    ),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: LeaderboardCubit.get(context).leaderboardModel != null && state is! getLeaderboardLoadingState,
                        builder: (context) => ListView.separated(
                          itemCount: LeaderboardCubit.get(context).leaderboardModel!.length,
                          itemBuilder: (context, index) {
                              return buildList((index+1), LeaderboardCubit.get(context).leaderboardModel![index].name, LeaderboardCubit.get(context).leaderboardModel![index].score);
                          },
                          separatorBuilder: (context, state) => const SizedBox(height: 10,),
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator(),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(index, name, score)
  {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
                child: Text(index.toString(), style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            SizedBox(width: 20,),
            Text(name, style: TextStyle(color: Colors.white, fontSize: 20),),
            Spacer(),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey))),
                child: Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 20,),)
            ),
          ],
        ),
      ),
    );
  }
}
