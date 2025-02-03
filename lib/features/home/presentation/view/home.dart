import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:googleapis/mybusinessaccountmanagement/v1.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/routes_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/home/presentation/view/semester_navigate.dart';
import 'package:lol/core/models/admin/announcement_model.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import 'package:lol/core/models/profile/profile_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/features/leaderboard/presentation/view/leaderboard_view.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/subject_details.dart';
import 'package:lol/features/support_and_about_us/about_us.dart';
import 'package:lol/features/support_and_about_us/user_advices/feedback_screen.dart';
import 'package:lol/features/support_and_about_us/user_advices/report_bug.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/widgets/snack.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/features/profile/view/profile.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/utils/dependencies_helper.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../admin/presentation/view/announcements/announcements_list.dart';
import '../../../admin/presentation/view/admin_panal.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit()..getProfileInfo(),
        ),
        BlocProvider(
          create: (context) => AdminCubit(),
        ),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if (state is Logout) {
            showToastMessage(
              message: StringsManager.logOutSuccessfully,
              states: ToastStates.SUCCESS,
            );
          }
        },
        builder: (context, state) {
          bool wannaAnnouncements = true;

          if (state is GetProfileSuccess) {
            if (MainCubit.get(context).profileModel!.photo == null) {
              MainCubit.get(context).updateUser(
                userID: MainCubit.get(context).profileModel!.id,
                photo: AppConstants.defaultProfileImage
              );
            }
            MainCubit.get(context).updateUser(
              userID: MainCubit.get(context).profileModel!.id,
              fcmToken: fcmToken
            );
          }

          if ((state is GetProfileSuccess || AppConstants.TOKEN == null) && wannaAnnouncements) {
            if (AppConstants.TOKEN == null) {
              BlocProvider.of<AdminCubit>(context).getAnnouncements(AppConstants.SelectedSemester!);
            } else {
              BlocProvider.of<AdminCubit>(context).getAnnouncements(MainCubit.get(context).profileModel!.semester);
            }
            wannaAnnouncements = false;
          }

          ProfileModel? profile;
          int? semesterIndex;
          if (MainCubit.get(context).profileModel != null) {
            profile = MainCubit.get(context).profileModel!;
            print(profile.name);
          }

          if (profile != null) {
            semesterIndex = semsesterIndex(profile.semester);
          } else if (AppConstants.TOKEN == null) {
            semesterIndex = semsesterIndex(AppConstants.SelectedSemester!);
          }

          return profile == null && AppConstants.TOKEN != null ?
          const Scaffold(body: Center(child: CircularProgressIndicator()),) :
          Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if ((AppConstants.TOKEN != null &&
                          profile != null) ||
                          AppConstants.TOKEN == null) {
                        scaffoldKey.currentState!.openDrawer(); // Use key to open the drawer
                      }
                    },
                    icon: Icon(IconsManager.filledGridIcon, color: Theme.of(context).appBarTheme.iconTheme!.color,)
                ),//drawer icon
              centerTitle: true,
              title: Text(
                StringsManager.home,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.semiBold),
              ),
            ),
            drawer: _customDrawer(
              context,
              AppConstants.TOKEN == null ?
              AppConstants.SelectedSemester :
              MainCubit.get(context).profileModel!.semester
            ),
            body: profile == null && AppConstants.TOKEN != null ?
            const Center(child: CircularProgressIndicator(),) :
            RefreshIndicator(
              onRefresh: () => _onRefresh(context, profile != null? profile.semester: AppConstants.SelectedSemester),
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(AppPaddings.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p20, vertical: AppPaddings.p10),
                          child: Text(
                            StringsManager.announcements,
                            style: Theme.of(context).textTheme.headlineLarge
                          ),
                        ), //Announcements Text
                        BlocBuilder<AdminCubit, AdminCubitStates>(
                          builder: (context, state) {
                            if (AdminCubit.get(context).announcements == null) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              var announcements = AdminCubit.get(context).announcements;
                              return CarouselSlider(
                                items: announcements!.isEmpty ? [
                                  GestureDetector(
                                    onDoubleTap: () {
                                      if (MainCubit.get(context).profileModel?.role == KeysManager.admin && changeSemester!) {
                                        MainCubit.get(context).updateSemester4all();
                                        changeSemester = false;
                                      }
                                    },
                                    onTap: () {
                                      navigate(
                                        context,
                                        AnnouncementsList(
                                          semester: MainCubit.get(context).profileModel!.semester
                                        )
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppSizesDouble.s15),
                                      ),
                                      child: Image.asset(
                                        height: AppSizesDouble.s600,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        AssetsManager.noAnnouncements
                                      ),
                                    ),
                                  )
                                ] :
                                announcements.map((announc) {
                                  return GestureDetector(
                                    onTap: () {
                                      navigate(
                                        context,
                                        AnnouncementDetail(
                                          title: announc.title,
                                          date: announc.dueDate,
                                          description: announc.content,
                                          semester: AppConstants.TOKEN != null ?
                                          MainCubit.get(context).profileModel!.semester :
                                          AppConstants.SelectedSemester!,
                                        )
                                      );
                                    },
                                    onDoubleTap: () {
                                      if(MainCubit.get(context).profileModel?.role == KeysManager.admin && changeSemester!) {
                                        MainCubit.get(context).updateSemester4all();
                                        changeSemester = false;
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: AppMargins.m5),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppSizesDouble.s15),
                                          ),
                                          child: Image.network(
                                            announc.image,
                                            width: AppSizesDouble.s400,
                                            height: AppSizesDouble.s250,
                                            fit: BoxFit.cover,
                                          ),
                                        ), //image
                                        Container(
                                          width: double.infinity,
                                          height: double.infinity, // Adjust height as needed
                                          decoration:
                                          BoxDecoration(
                                            gradient:
                                              LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(AppSizesDouble.s0_3),
                                                  Colors.black.withOpacity(AppSizesDouble.s0_6),
                                                ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(AppSizesDouble.s15)
                                          ),
                                        ), //gradient
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: AppMargins.m20, horizontal: AppMargins.m15),
                                            child: Stack(
                                              children: [
                                                Text(
                                                  announc.title,
                                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                    foreground: Paint()
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeWidth = AppSizesDouble.s1_8
                                                    ..color = ColorsManager.black
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: AppSizes.s1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  announc.title,
                                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                    color: ColorsManager.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: AppSizes.s1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ]
                                            ),
                                          ),
                                        ), //title
                                      ]
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  height: AppSizesDouble.s200,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  aspectRatio: AppSizes.s16 / AppSizes.s9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: announcements.length < AppSizes.s5 ? false : true,
                                  autoPlayInterval: const Duration(seconds: AppSizes.s5),
                                  autoPlayAnimationDuration: const Duration(milliseconds: AppSizes.s800),
                                  viewportFraction: announcements.isEmpty ? AppSizesDouble.s1 : AppSizesDouble.s0_8,
                                ),
                              );
                            }
                          }
                        ), //Announcements Carousel Slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p20, vertical: AppPaddings.p20),
                          child: divider(),
                        ), //divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                          child: Text(
                            StringsManager.subject,
                            style: Theme.of(context).textTheme.headlineLarge
                          ),
                        ), // Subjects Text
                        Padding(
                          padding: const EdgeInsets.all(AppPaddings.p10),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
                            shrinkWrap: true, // Shrink the GridView to fit its content
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: AppSizes.s2, // Two items per row
                              crossAxisSpacing: AppSizesDouble.s10,
                              mainAxisSpacing: AppSizesDouble.s10,
                            ),
                            itemCount: semesters[semesterIndex!].subjects.length,
                            itemBuilder: (context, index) {
                              return subjectItemBuild(
                                semesters[semesterIndex!].subjects[index],
                                context,
                                false
                              );
                            },
                          ),
                        ), //Subjects Grid
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

Future<void> _onRefresh(context, semester) async{
  AdminCubit.get(context).getAnnouncements(semester);
  return Future.value();
}

Widget _customDrawer(context, semester) {
  var cubit = MainCubit.get(context);
  ProfileModel? profileModel;
  if (AppConstants.TOKEN != null) profileModel = MainCubit.get(context).profileModel;

  return Drawer(
    //backgroundColor: isDark ? Colors.black : Colors.white,
    width: AppQueries.screenWidth(context) < AppSizes.s600 ? AppQueries.screenWidth(context) / AppSizesDouble.s1_5 : AppQueries.screenWidth(context) / AppSizesDouble.s2_5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        AppConstants.TOKEN != null
          ? SizedBox(
            height: AppQueries.screenHeight(context) / AppSizesDouble.s3_2,
            child: UserAccountsDrawerHeader(
              otherAccountsPictures: [
                IconButton(
                  onPressed: () {
                    cubit.changeAppMode();
                  },
                  icon: Icon(
                    cubit.isDark ? IconsManager.lightModeIcon : IconsManager.darkModeIcon,
                    color: Theme.of(context).iconTheme.color,
                  )
                )
              ],

              decoration: BoxDecoration(color: Theme.of(context).drawerTheme.backgroundColor),
              accountName: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) / AppSizesDouble.s1_5),
                        child: Text(
                          profileModel!.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: AppSizes.s1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppConstants.Level(profileModel.semester),
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                    ],
                  ),
              // accountEmail: Text("2nd year "),
              accountEmail: Container(
                margin: EdgeInsets.zero, // Remove any margin
                padding: EdgeInsets.zero, // Remove any padding
                child: Padding(
                  padding: const EdgeInsets.only(top: AppPaddings.p5),
                  child: GestureDetector(
                    onTap: () => navigate(context, const Profile()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(IconsManager.personIcon),
                        SizedBox(width: AppSizesDouble.s10),
                        Text(StringsManager.profileInfo, style: Theme.of(context).textTheme.bodyLarge,),
                      ],
                    ),
                  ),
                ),
              ),
              currentAccountPicture: ClipOval(
                child: Image.network(
                  profileModel.photo ?? AppConstants.defaultProfileImage,
                  width: AppSizesDouble.s10,
                  height: AppSizesDouble.s10,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ) :
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          accountName: const Text(StringsManager.guest),
          accountEmail: Text(
            AppConstants.Level(AppConstants.SelectedSemester!),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          // accountEmail:InkWell(
                //   child: Ink(
                //     child: Text(
                //       // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                //       // onPressed: () {
                //       //   Navigator.push(
                //       //       context,
                //       //       MaterialPageRoute(
                //       //           builder: (context) => const LoginScreen()));
                //       // },
                //       // child: const Text(
                //         "Login",
                //         style: TextStyle(color: Colors.white),

                //     ),
                //   ),
                // ) ,
          currentAccountPicture: const CircleAvatar(
            backgroundImage: NetworkImage(AppConstants.defaultProfileImage),
          ),
          otherAccountsPictures: [
            IconButton(
              onPressed: () {
                MainCubit.get(context).changeAppMode();
              },
              icon: Icon(
                cubit.isDark ? IconsManager.lightModeIcon : IconsManager.darkModeIcon,
                color: Theme.of(context).iconTheme.color,
              )
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                if (profileModel?.role == KeysManager.admin)
                ListTile(
                  leading: Icon(
                    IconsManager.adminIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.admin,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  onTap: () => navigate(context, AdminPanel()),
                ),
                ListTile(
                  leading: Icon(
                    IconsManager.announcementsIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.announcements,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  onTap: () {
                    if (AppConstants.TOKEN == null) {
                      navigate(context, AnnouncementsList(semester: AppConstants.SelectedSemester!));
                    } else {
                      navigate(
                        context,
                        AnnouncementsList(
                          semester: MainCubit.get(context).profileModel!.semester
                        )
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    IconsManager.leaderboardIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.leaderboard,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  onTap: () {
                    navigate(
                      context,
                      LeaderboardScreen(
                        semester: semester,
                      )
                    );
                  },
                ),
                ExpansionTile(
                  leading: Icon(
                    IconsManager.schoolIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.years,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                  children: [
                    ExpansionTile(
                      title: Text(
                        StringsManager.firstYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                      childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.one));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.two));
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        StringsManager.secondYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.three));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.four));
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        StringsManager.thirdYear,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                      childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                      children: [
                        ListTile(
                          title: Text(
                            StringsManager.firstSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.five));
                          },
                        ),
                        ListTile(
                          title: Text(
                            StringsManager.secondSemester,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                          onTap: () {
                            navigate(context, SemesterNavigate(semester: StringsManager.six));
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => showToastMessage(
                        message: StringsManager.currentlyUpdating,
                        states: ToastStates.INFO
                      ),
                      child: ExpansionTile(
                        enabled: false,
                        title: Text(
                          StringsManager.seniors,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        //currently Not Used
                        children: [
                          ListTile(
                            title: const Text("First Semester"),
                            onTap: () {
                              // MainCubit.get(context).profileModel = null;
                              // TOKEN = null;
                              navigate(context,
                                  const SemesterNavigate(semester: "One"));
                            },
                          ),
                          ListTile(
                            title: const Text("Second Semester"),
                            onTap: () {
                              // MainCubit.get(context).profileModel = null;
                              // TOKEN = null;
                              navigate(context,
                                  const SemesterNavigate(semester: "Two"));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Image.asset(
                    AssetsManager.drive,
                    width: AppSizesDouble.s25,
                    height: AppSizesDouble.s25,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.drive,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                  childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                  children: [
                    ListTile(
                      title: Text(
                        StringsManager.year28,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                          StringsManager.drive.toLowerCase(),
                          AppConstants.year28Drive
                        );
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year27,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                          StringsManager.drive.toLowerCase(),
                          AppConstants.year27Drive
                        );
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year26,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                          StringsManager.drive.toLowerCase(),
                          AppConstants.year26Drive
                        );
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year25,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                          StringsManager.drive.toLowerCase(),
                          AppConstants.year25Drive
                        );
                        await onOpen(context, url);
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.year24,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () async {
                        LinkableElement url = LinkableElement(
                          StringsManager.drive.toLowerCase(),
                          AppConstants.year24Drive
                        );
                        await onOpen(context, url);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(
                    IconsManager.supportAgentIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.support,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when expanded
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Removes divider when collapsed
                  childrenPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                  children: [
                    ListTile(
                      title: Text(
                        StringsManager.reportBug,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        navigate(context, ReportBug());
                      },
                    ),
                    ListTile(
                      title: Text(
                        StringsManager.feedback,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        navigate(context, FeedbackScreen());
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(
                    IconsManager.groupIcon,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    StringsManager.aboutUs,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    navigate(context, AboutUs());
                  },
                ),
              ],
            )
          ),
        ),
        // login/logout button
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppPaddings.p20),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context)/AppSizes.s2, minWidth: AppSizesDouble.s150),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.TOKEN != null ? ColorsManager.imperialRed: ColorsManager.green,
                  padding: EdgeInsets.symmetric(vertical: AppPaddings.p15)
                ),
                onPressed: (){
                  if(AppConstants.TOKEN != null) {
                    AwesomeDialog(
                      context: context,
                      title: StringsManager.logOut,
                      dialogType: DialogType.warning,
                      dismissOnTouchOutside: true,
                      barrierColor: ColorsManager.black.withOpacity(AppSizesDouble.s0_7),
                      body: Text(
                        StringsManager.logOutWarningMessage,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.black),
                        textAlign: TextAlign.center,
                      ),
                      animType: AnimType.scale,
                      btnOkColor: ColorsManager.imperialRed,
                      btnCancelOnPress: () {},
                      btnOkText: StringsManager.logOut,
                      btnCancelColor: ColorsManager.grey,

                      btnOkOnPress: () {
                        MainCubit.get(context).logout(context);
                        Cache.writeData(key: KeysManager.isDark, value: false);
                      },
                    ).show();
                  }
                  else{
                    Cache.writeData(key: KeysManager.isDark, value: false);
                    navigate(context, LoginScreen());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppConstants.TOKEN != null? IconsManager.logOutIcon: IconsManager.logInIcon,
                      color: ColorsManager.white
                    ),
                    SizedBox(width: AppSizesDouble.s10,),
                    Text(
                      AppConstants.TOKEN != null? StringsManager.logOut : StringsManager.logIn,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.semiBold),
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
        // Container(
        //   width: 150,
        //   height: 50,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     color: AppConstants.TOKEN != null ? Colors.red : Colors.green
        //   ),
        //   child: AppConstants.TOKEN != null
        //     ? InkWell(
        //       onTap: () {
        //         AwesomeDialog(
        //           context: context,
        //           title: StringsManager.logOut,
        //           dialogType: DialogType.warning,
        //           dismissOnTouchOutside: true,
        //           barrierColor: ColorsManager.black.withOpacity(AppSizesDouble.s0_7),
        //           body: Text(
        //             StringsManager.logOutWarningMessage,
        //             style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.black),
        //             textAlign: TextAlign.center,
        //           ),
        //           animType: AnimType.scale,
        //           btnOkColor: ColorsManager.imperialRed,
        //           btnCancelOnPress: () {},
        //           btnOkText: StringsManager.logOut,
        //           btnCancelColor: ColorsManager.grey,
        //
        //           btnOkOnPress: () {
        //             MainCubit.get(context).logout(context);
        //             Cache.writeData(key: KeysManager.isDark, value: false);
        //           },
        //         ).show();
        //       },
        //       child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Icon(
        //               Icons.logout,
        //               color: Colors.white,
        //               size: 24,
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             const Text(
        //               "Log out",
        //               style: TextStyle(
        //                   color: Colors.white, fontSize: 17),
        //             ),
        //           ]
        //       ),
        //   ) :
        //   GestureDetector(
        //     onTap: () {
        //       Cache.writeData(key: KeysManager.isDark, value: false);
        //       navigate(context, LoginScreen());
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Icon(
        //           Icons.login,
        //           color: Colors.white,
        //           size: 24,
        //         ),
        //         SizedBox(
        //           width: 10,
        //         ),
        //         const Text(
        //           "Log in",
        //           style: TextStyle(
        //               color: Colors.white, fontSize: 17),
        //         ),
        //       ]
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

Widget subjectItemBuild(SubjectModel subject, context, bool navigation) {
  return GestureDetector(
    onTap: () {
      navigate(
        context,
        BlocProvider(
          create: (context) => GetMaterialCubit(getIt.get<SubjectRepoImp>()),
          child: SubjectDetails(
            navigate: false,
            subjectName: subject.subjectName,
          ),
        )
      );
    },
    child: Card(
      elevation: AppSizesDouble.s12, // More elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(AppPaddings.p10),
        decoration: BoxDecoration(
          color: MainCubit.get(context).isDark ? ColorsManager.grey1 : ColorsManager.lightPrimary
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(subject.subjectImage, height: AppSizesDouble.s70, color: Colors.white),
            SizedBox(
              height: AppSizesDouble.s10,
            ),
            Text(
              textAlign: TextAlign.center,
              subject.subjectName.replaceAll(StringsManager.underScore, StringsManager.space).replaceAll(StringsManager.andWord, StringsManager.andSymbol),
              maxLines: AppSizes.s2,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.semiBold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}