import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import  'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/constants.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers:[
        BlocProvider(create: (context) => MainCubit()..getProfileInfo()),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if (TOKEN == null)
          {
              MainCubit.get(context).getLeaderboard(SelectedSemester);
          }
          else
          {
            if(state is GetProfileSuccess)
            {
                MainCubit.get(context).getLeaderboard(MainCubit.get(context).profileModel!.semester);
            }
          }
        },
        builder: (context, state) => Scaffold(
          key: scaffoldKey,
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
                    adminTopTitleWithDrawerButton(
                      title: 'Leaderboard',
                      hasDrawer: true,
                      size: 35,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: divider(),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10.0),
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
                        condition: MainCubit.get(context).notAdminLeaderboardModel != null && state is! GetLeaderboardLoadingState,
                        builder: (context) {
                          return ListView.separated(
                            itemCount: MainCubit.get(context).notAdminLeaderboardModel!.length,
                            itemBuilder: (context, index) {
                              return buildList(
                                (index + 1),
                                MainCubit.get(context).notAdminLeaderboardModel![index].name,
                                MainCubit.get(context).notAdminLeaderboardModel![index].score
                              );
                            },
                            separatorBuilder: (context, state) => const SizedBox(height: 10,),
                          );
                        },
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(index, name, score) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: Text(index.toString(), style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Spacer(),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey))),
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
