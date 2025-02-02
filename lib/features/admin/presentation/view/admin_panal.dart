import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/main.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/add_announcement.dart';
import 'package:lol/features/admin/presentation/view/requests/requests.dart';

import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';

import '../../../../core/utils/resources/constants_manager.dart';
import 'announcements/announcements_list.dart';
import '../../../auth/presentation/view/login.dart';
import '../../../home/presentation/view/home.dart';
import '../../../profile/view/profile.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()..getProfileInfo()),
        BlocProvider(create: (context) => AdminCubit()),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var mainCubit = MainCubit.get(context);
          return Scaffold(
            //backgroundColor: HexColor('#23252A'),
            body: Container(
              margin:
                  EdgeInsetsDirectional.only(top: AppQueries.screenHeight(context) / 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button
                  Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 5,
                        child: IconButton(
                          // padding: EdgeInsets.zero,
                          // materialTapTargetSize:
                          //     MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            navigatReplace(context, Home());
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Buttons
                  ConditionalBuilder(
                    condition: MainCubit.get(context).profileModel != null &&
                        state is! GetProfileLoading,
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                    builder: (context) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 13,
                          width: AppQueries.screenWidth(context) - 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: isDark ? Colors.white : HexColor('#3B3B3B'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (mainCubit.profileModel != null) {
                              navigate(
                                  context,
                                  AddAnnouncement(
                                      semester:
                                          mainCubit.profileModel!.semester));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? HexColor('#3B3B3B')
                                : HexColor('#757575'),
                            padding: EdgeInsets.zero, // Remove default padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: Size(AppQueries.screenWidth(context) - 40, AppQueries.screenHeight(context) / 4.5),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.campaign,
                                  color: Colors.white, size: AppQueries.screenWidth(context) / 4),
                              Text('Announcements',
                                  style: TextStyle(
                                      fontSize: AppQueries.screenWidth(context) / 15,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 13,
                          width: AppQueries.screenWidth(context) - 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: isDark ? Colors.white : HexColor('#3B3B3B'),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              navigate(context, Requests());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 20, 130, 220),
                              padding:
                                  EdgeInsets.zero, // Remove default padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size(AppQueries.screenWidth(context) - 40, AppQueries.screenHeight(context) / 4.5),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.email,
                                    color: Colors.white, size: AppQueries.screenWidth(context) / 4),
                                Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontSize: AppQueries.screenWidth(context) / 15,
                                      color: Colors.white),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
