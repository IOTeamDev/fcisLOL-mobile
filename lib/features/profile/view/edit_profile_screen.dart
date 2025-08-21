import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/presentation/app_icons.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:lol/features/pick_image/presentation/view_model/pick_image_cubit/pick_image_cubit.dart';
import 'package:lol/features/profile/view/widgets/basic_info_edit.dart';
import 'package:lol/features/profile/view/widgets/delete_account_section.dart';
import 'package:lol/features/profile/view/widgets/login_info_edit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar_view.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, animationDuration: Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PickImageCubit, PickImageState>(
      listener: (context, state) {
        if (state is UploadImageSuccess) {
          context
              .read<PickImageCubit>()
              .updateProfileImage(imageUrl: state.imageUrl);
        }
        if (state is UpdateUserImageSuccess) {
          _refreshProfileModel();
          showToastMessage(
            message: 'Profile image updated successfully',
            states: ToastStates.SUCCESS,
          );
        }
        if (state is UploadImageFailed) {
          showToastMessage(
            message: state.errMessage,
            states: ToastStates.ERROR,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.editProfile,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocBuilder<MainCubit, MainCubitStates>(
              builder: (context, state) {
                return SizedBox(
                  height: ScreenSize.width(context) / AppSizes.s3,
                  width: ScreenSize.width(context) / AppSizes.s3,
                  child: InkWell(
                    splashColor: ColorsManager.transparent,
                    onTap: () async {
                      final cubit = context.read<PickImageCubit>();
                      final image = await cubit.pickImage();
                      if (image != null) {
                        await cubit.deleteUserImage(
                            image: getImageNameFromUrl(
                                imageUrl: context
                                    .read<MainCubit>()
                                    .profileModel!
                                    .photo!));
                        await cubit.uploadUserImage(image: image);
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: ScreenSize.width(context) / AppSizes.s5,
                          backgroundImage: NetworkImage(
                              MainCubit.get(context).profileModel?.photo ??
                                  AppConstants.defaultProfileImage),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorsManager.black
                                  .withValues(alpha: AppSizesDouble.s0_4),
                              borderRadius:
                                  BorderRadius.circular(AppSizesDouble.s100)),
                          width:
                              ScreenSize.width(context) / AppSizesDouble.s2_5,
                          height:
                              ScreenSize.width(context) / AppSizesDouble.s2_5,
                          child: Icon(
                            AppIcons.editIcon,
                            size: ScreenSize.width(context) / AppSizes.s4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: AppSizesDouble.s30,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(AppPaddings.p5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSizesDouble.s40)),
                    color: ColorsManager.grey5),
                height: ScreenSize.height(context) / AppSizesDouble.s1_5,
                child: Column(
                  children: [
                    TabBar(
                        indicatorColor: ColorsManager.lightPrimary,
                        indicatorWeight: AppSizesDouble.s1,
                        indicatorAnimation: TabIndicatorAnimation.elastic,
                        labelColor: ColorsManager.lightPrimary,
                        dividerColor: ColorsManager.darkPrimary,
                        unselectedLabelColor: ColorsManager.lightGrey,
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(),
                        tabs: [
                          Tab(
                            text: AppStrings.personalInfo,
                            height: AppSizesDouble.s40,
                          ),
                          Tab(
                            height: AppSizesDouble.s40,
                            text: AppStrings.changePassword,
                          ),
                          // Tab(
                          //   height: AppSizesDouble.s40,
                          //   child: FittedBox(
                          //     child: AnimatedBuilder(
                          //       animation: _tabController,
                          //       builder: (context, _) {
                          //         final isLastTabSelected =
                          //             _tabController.index == AppSizes.s2;
                          //         return AnimatedDefaultTextStyle(
                          //           child: Text(
                          //             AppStrings.deleteAccount,
                          //           ),
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: AppSizesDouble.s16,
                          //             color: isLastTabSelected
                          //                 ? ColorsManager.imperialRed
                          //                 : ColorsManager.darkRed,
                          //           ),
                          //           duration:
                          //               Duration(milliseconds: AppSizes.s70),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ]),
                    Expanded(
                        child: TabBarView(children: [
                      BasicInfoEdit(
                        semester: MainCubit.get(context).profileModel!.semester,
                        phone: MainCubit.get(context).profileModel!.phone,
                        userName: MainCubit.get(context).profileModel!.name,
                        email: MainCubit.get(context).profileModel!.email,
                      ),
                      LoginInfoEdit(),
                      // DeleteAccountSection(),
                    ], controller: _tabController))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshProfileModel() async {
    log('old photo =>  ${context.read<MainCubit>().profileModel?.photo}');
    await context.read<MainCubit>().getProfileInfo();
  }
}
