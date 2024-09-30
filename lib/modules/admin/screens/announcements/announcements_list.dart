import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/components/navigation.dart';

class AnnouncementsList extends StatelessWidget {
  const AnnouncementsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..getAnnouncements(),
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state){},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                backgroundEffects(),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 50),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        backButton(context),
                        adminTopTitleWithDrawerButton(hasDrawer: false, title: 'Announcements', size: 34),
                        ConditionalBuilder(
                          condition:
                          state is! AdminGetAnnouncementLoadingState &&
                              cubit.announcements != null &&
                              cubit.announcements!.isNotEmpty,
                          builder: (context) => ListView.separated(
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
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                            itemCount: cubit.announcements!.length,
                            //cubit.announcements!.length
                          ),
                          fallback: (context) {
                            if (state is AdminGetAnnouncementLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return const Center(
                                child: Text(
                                  'You have no announcements yet!!!',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget announcementBuilder(int id, BuildContext context, String title, int index, String content, dueDate, type) {
    return GestureDetector(
      onTap: (){
        navigate(context, AnnouncementDetail(title: title, description: content, date: dueDate, id: id, selectedType: type));
      },
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [HexColor('8D10FA').withOpacity(0.45) , HexColor('DA22FF').withOpacity(0.45)], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 20),),
            SizedBox(height: 10,),
            Text(content, style: TextStyle(color: Colors.grey, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis,),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(dueDate, style: TextStyle(color: Colors.white, fontSize: 14),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
