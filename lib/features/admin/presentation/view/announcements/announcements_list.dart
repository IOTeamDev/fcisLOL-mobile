import 'dart:math';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';

class AnnouncementsList extends StatefulWidget {
  final String semester;
  AnnouncementsList({super.key, required this.semester});

  @override
  State<AnnouncementsList> createState() => _AnnouncementsListState();
}

class _AnnouncementsListState extends State<AnnouncementsList> {
  final List<String> _items = [
    'All',
    'Faculty',
    'Summer_Training',
    'Workshop',
    'Final',
    'Practical',
    'Assignment',
    'Quiz',
    'Other',
  ];
  late String filteredValue;

  @override
  void initState() {
    filteredValue = _items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              StringsManager.announcements,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(IconsManager.filterIcon, color: Theme.of(context).iconTheme.color),
                color: ColorsManager.white,
                style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(ColorsManager.black)),
                onSelected: (value) {
                  setState(() {
                    filteredValue = value;
                  });
                },
                itemBuilder: (context) {
                  return _items.map(
                  (item) => PopupMenuItem(
                    value: item,
                    child: Text(item.replaceAll(StringsManager.underScore, StringsManager.space), style: TextStyle(color: ColorsManager.black)),
                  ),
                ).toList();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPaddings.p20),
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: ConditionalBuilder(
                  condition: state is! AdminGetAnnouncementLoadingState,
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  builder: (context) => ListView.separated(
                    //shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if(filteredValue == _items[0])
                      {
                        return announcementBuilder(
                          cubit.announcements[index].id,
                          context,
                          cubit.announcements[index].title,
                          index,
                          cubit.announcements[index].content,
                          cubit.announcements[index].dueDate,
                          cubit.announcements[index].type
                        );
                      }else{
                        if(cubit.announcements[index].type == filteredValue){
                          return announcementBuilder(
                            cubit.announcements[index].id,
                            context,
                            cubit.announcements[index].title,
                            index,
                            cubit.announcements[index].content,
                            cubit.announcements[index].dueDate,
                            cubit.announcements[index].type
                          );
                        }
                        else{
                          return null;
                        }
                      }
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: AppSizesDouble.s10,
                    ),
                    itemCount: cubit.announcements.length,
                    //cubit.announcements!.length
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(context) async {
    AdminCubit.get(context).getAnnouncements(widget.semester);
    return Future.value();
  }

  Widget announcementBuilder(int id, BuildContext context, String title,
      int index, String content, dueDate, type) {
    return GestureDetector(
      onTap: () {
        navigate(
          context,
          AnnouncementDetail(
            semester: widget.semester,
            title: title,
            description: content,
            date: dueDate,
          )
        );
      },
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m10),
        padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppPaddings.p20, vertical: AppPaddings.p10),
        constraints: BoxConstraints(
          maxHeight: AppQueries.screenHeight(context) / AppSizes.s4,
          minHeight: AppSizesDouble.s100,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizesDouble.s20),
            color: Provider.of<ThemeProvider>(context).isDark
                ? ColorsManager.darkPrimary
                : ColorsManager.lightPrimary),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isArabicLanguage(context)? CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: ColorsManager.white),
              maxLines: AppSizes.s2,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
              child: Text(
                content,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: ColorsManager.grey2),
                maxLines: AppSizes.s3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  dueDate == StringsManager.noDueDate
                      ? dueDate
                      : DateFormat(StringsManager.dateFormat)
                          .format(DateTime.parse(dueDate))
                          .toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
