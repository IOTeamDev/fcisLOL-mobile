import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/layout/home/bloc/main_cubit.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/modules/admin/screens/requests/requests.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';

import '../../modules/admin/screens/announcements/announcements_list.dart';
import '../../modules/auth/screens/login.dart';
import '../home/home.dart';
import '../profile/profile.dart';

class AdminPanal extends StatelessWidget {

  AdminPanal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()..getProfileInfo()),
        BlocProvider(create: (context) => AdminCubit()),
      ],
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state) {},
        builder:(context, state) {
          return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
            backgroundEffects(),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 50),
              width: double.infinity,
              child: Column(
                children: [
                  // Back Button
                  backButton(context),
                  // Text With Drawer Button
                  adminTopTitleWithDrawerButton(
                      title: 'Admin',
                      hasDrawer: true,
                      bottomPadding: 50),
                  // Buttons
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsetsDirectional.symmetric(horizontal: 30),
                    height: 260,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                navigate(context, const AddAnouncment());
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero, // Remove default padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(250, 125),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('images/admin/Frame 4.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width: 250,
                                  height: 125,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Announcements',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                navigate(context, Requests());
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero, // Remove default padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(250, 125),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('images/admin/Frame 2.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width: 250,
                                  height: 125,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Requests',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Image(
                      image: AssetImage('images/admin/background_admin.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
        },
      ),
    );
  }
}
