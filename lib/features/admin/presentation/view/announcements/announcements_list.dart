import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/navigation.dart';
import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/constants_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';

class AnnouncementsList extends StatelessWidget {
  final String semester;
  const AnnouncementsList({super.key, required this.semester});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(StringsManager.announcements, style: Theme.of(context).textTheme.displayMedium,),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPaddings.p20),
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => announcementBuilder(
                            cubit.announcements![index].id,
                            context,
                            cubit.announcements![index].title,
                            index,
                            cubit.announcements![index].content,
                            cubit.announcements![index].dueDate,
                            cubit.announcements![index].type),
                        separatorBuilder: (context, index) => const SizedBox(height: AppSizesDouble.s10,),
                        itemCount: cubit.announcements!.length,
                        //cubit.announcements!.length
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  _onRefresh(context){
    AdminCubit.get(context).getAnnouncements(semester);
  }
  Widget announcementBuilder(int id, BuildContext context, String title,
      int index, String content, dueDate, type) {
    var random = Random();
    int rand = random.nextInt(ColorsManager.announcementsColorList.length);
    return GestureDetector(
      onTap: () {
        navigate(
          context,
          AnnouncementDetail(
            semester: semester, //
            title: title,
            description: content,
            date: dueDate,
          ));
      },
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 15),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorsManager.announcementsColorList[rand]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              content,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  dueDate == 'No Due Date'
                      ? dueDate
                      : DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(dueDate))
                          .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
