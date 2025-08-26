import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit_states.dart';
import 'package:lol/core/presentation/screen_size.dart' show ScreenSize;
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/core/resources/theme/values/values_manager.dart';
import 'package:lol/features/profile/view/other_profile.dart';
import 'package:lol/main.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/constants/constants_manager.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatelessWidget {
  final String semester;
  const LeaderboardScreen({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (MainCubit.get(context).notAdminLeaderboardModel == null) {
          MainCubit.get(context).getLeaderboard(semester);
        }
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppStrings.leaderboard,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight:
                            ScreenSize.height(context) / AppSizesDouble.s1_1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: AppPaddings.p10),
                      child: ConditionalBuilder(
                        condition:
                            MainCubit.get(context).notAdminLeaderboardModel !=
                                    null &&
                                state is! GetLeaderboardLoadingState &&
                                (MainCubit.get(context)
                                            .notAdminLeaderboardModel
                                            ?.length ??
                                        AppSizes.s0) >=
                                    AppSizes.s3,
                        builder: (context) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ScreenSize.height(context) / AppSizes.s80,
                            ),
                            //Top 3 Contributors Stages
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: AppPaddings.p10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _topThreeBuilder(
                                      context,
                                      AppSizes.s1,
                                      AppStrings.twoNum,
                                      AppSizes.s4,
                                      AppSizesDouble.s35,
                                      ColorsManager.darkLightPrimary,
                                      ColorsManager.silver),
                                  _topThreeBuilder(
                                      context,
                                      AppSizes.s0,
                                      AppStrings.oneNum,
                                      AppSizesDouble.s3_2,
                                      AppSizesDouble.s40,
                                      ColorsManager.lightPrimary,
                                      ColorsManager.gold),
                                  _topThreeBuilder(
                                      context,
                                      AppSizes.s2,
                                      AppStrings.threeNum,
                                      AppSizes.s5,
                                      AppSizesDouble.s30,
                                      ColorsManager.darkLightPrimary,
                                      ColorsManager.bronze),
                                ],
                              ),
                            ),
                            divider(),
                            //Other Contributors
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppPaddings.p10),
                              child: ConditionalBuilder(
                                condition: MainCubit.get(context)
                                        .notAdminLeaderboardModel!
                                        .length >
                                    AppSizes.s4,
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
                                              AppSizes.s4
                                      ? (MainCubit.get(context)
                                                  .notAdminLeaderboardModel!
                                                  .length >=
                                              AppSizes.s10
                                          ? AppSizes.s12
                                          : MainCubit.get(context)
                                                  .notAdminLeaderboardModel!
                                                  .length -
                                              AppSizes.s3)
                                      : AppSizes.s0,
                                  itemBuilder: (context, index) {
                                    return buildList(
                                        context,
                                        (index + AppSizes.s4),
                                        MainCubit.get(context)
                                            .notAdminLeaderboardModel![
                                                index + AppSizes.s3]
                                            .name,
                                        MainCubit.get(context)
                                            .notAdminLeaderboardModel![
                                                index + AppSizes.s3]
                                            .score,
                                        MainCubit.get(context)
                                            .notAdminLeaderboardModel![
                                                index + AppSizes.s3]
                                            .id);
                                  },
                                  separatorBuilder: (context, state) => Padding(
                                    padding:
                                        const EdgeInsets.all(AppPaddings.p15),
                                    child: divider(
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                    .isDark
                                                ? ColorsManager.grey
                                                : ColorsManager.grey2),
                                  ),
                                ),
                                fallback: (context) => SizedBox(
                                    height: ScreenSize.height(context) /
                                        AppSizes.s3,
                                    child: Center(
                                      child: Text(
                                        AppStrings.noMoreUsers,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize:
                                                    ScreenSize.width(context) /
                                                        AppSizes.s12),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        fallback: (context) {
                          if (state is GetLeaderboardLoadingState) {
                            return SizedBox(
                                height: ScreenSize.height(context) /
                                    AppSizesDouble.s1_3,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ));
                          }
                          return SizedBox(
                              height: ScreenSize.height(context) /
                                  AppSizesDouble.s1_3,
                              child: Center(
                                child: Text(
                                  AppStrings.noLeaderBoard,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontSize: ScreenSize.width(context) /
                                              AppSizes.s12),
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
        );
      },
    );
  }

  Widget _topThreeBuilder(context, index, place, height, double rankSide,
          Color color, rankColor) =>
      GestureDetector(
        onTap: () => navigate(
          context,
          OtherProfile(
            id: MainCubit.get(context).notAdminLeaderboardModel![index].id,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(MainCubit.get(context)
                  .notAdminLeaderboardModel![index]
                  .photo!),
              radius: ScreenSize.width(context) / AppSizes.s11,
            ),
            SizedBox(
              height: AppSizesDouble.s3,
            ),
            ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: ScreenSize.width(context) / AppSizesDouble.s3_5),
                child: Text(
                  MainCubit.get(context).notAdminLeaderboardModel![index].name!,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: ScreenSize.width(context) / AppSizes.s19,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: AppSizes.s2,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: AppSizesDouble.s10,
            ),
            Container(
              padding:
                  EdgeInsetsDirectional.symmetric(vertical: AppPaddings.p20),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizesDouble.s15),
                    topRight: Radius.circular(AppSizesDouble.s15)),
              ),
              height: ScreenSize.height(context) / height,
              width: ScreenSize.width(context) / AppSizesDouble.s3_2,
              child: Column(
                children: [
                  Container(
                    height: rankSide,
                    width: rankSide,
                    decoration: BoxDecoration(
                        color: rankColor,
                        borderRadius:
                            BorderRadius.circular(AppSizesDouble.s10)),
                    child: Center(
                        child: Text(
                      place,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: ColorsManager.black,
                          fontSize: ScreenSize.width(context) / AppSizes.s18),
                    )),
                  ),
                  SizedBox(
                    height: AppSizesDouble.s10,
                  ),
                  Text(
                      MainCubit.get(context)
                              .notAdminLeaderboardModel![index]
                              .score
                              .toString() +
                          AppStrings.space +
                          AppStrings.pts,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              fontSize:
                                  ScreenSize.width(context) / AppSizes.s15,
                              color: ColorsManager.white))
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildList(context, index, name, score, id) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p15),
      child: SizedBox(
        height: AppSizesDouble.s50,
        width: double.infinity,
        child: Row(
          children: [
            Text(
              index.toString(),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Provider.of<ThemeProvider>(context).isDark
                      ? ColorsManager.lightGrey1
                      : ColorsManager.grey),
            ),
            SizedBox(
              width: AppSizesDouble.s15,
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: ScreenSize.width(context) / AppSizesDouble.s1_2),
                child: GestureDetector(
                  onTap: () => navigate(
                    context,
                    OtherProfile(
                      id: id,
                    ),
                  ),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p20),
              child: Text(
                '$score pts',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
