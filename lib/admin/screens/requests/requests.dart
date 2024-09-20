import 'dart:math';
import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/admin/bloc/admin_cubit.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/shared/components/components.dart';
import '../../../constants/constants.dart';

class Requests extends StatelessWidget {

  // String title;
  // String description;
  // String link;
  // String type;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> backgroundColor =
  [
    '94ffff',
    'ff94ad',
    'bc94ff',
    'add271',
    '5d5fff',
    'e17fd1',
    'b6bffe',
    '7d29fb',
    'ff5938',
    '00664e',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state){},
      builder:(context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold
        (
          key: scaffoldKey,
          drawer: drawerBuilder(context),
          backgroundColor: Colors.black,
          body: Stack
          (
            children:
            [
              backgroundEffects(),
              Container
              (
                margin: const EdgeInsetsDirectional.only(top: 50),
                width: double.infinity,
                child: Column
                (
                  children:
                  [
                    //backButton
                   backButton(context),
                    //Text With Drawer Button
                    adminTopTitleWithDrawerButton(title: 'Requests', size: 40, hasDrawer: false),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: state is !AdminGetRequestsLoadingState && cubit.requests != null &&  cubit.requests!.isNotEmpty,
                        builder: (context) => ListView.separated
                          (
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              //return Text('${cubit.requests![index].author?.authorName}', style: TextStyle(fontSize: 30, color: Colors.white),);
                              return requestedMaterialBuilder(
                                backgroundColor,
                                index,
                                title:'material Title',
                                type: cubit.requests![index].type,
                                pfp: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s',
                                authorName: cubit.requests![index].author?.name,
                                link: cubit.requests![index].link,
                                subjectName: 'Subject Name',
                                description: 'Lecture Or Chapter'
                              );
                            },
                            separatorBuilder: (context, index) =>
                            const Padding(padding: EdgeInsetsDirectional.all(5)),
                            itemCount: cubit.requests!.length
                        ),
                        fallback: (context)
                        {
                          if(state is AdminGetRequestsLoadingState)
                            {
                              return const Center(child: CircularProgressIndicator());
                            }
                          return Center(child: Text('You have no requests yet!!!!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),textAlign: TextAlign.center,),);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget requestedMaterialBuilder(List<String> colorText, index, {title, link, type, authorName, pfp, subjectName, description})
  {
    var random = Random();

    int min = 0;
    int max = 9;
    int randomNum = min + random.nextInt(max - min + 1);

    return Container(
      decoration: BoxDecoration(color: HexColor(colorText[randomNum]).withOpacity(0.45), borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      height: 150,
      child: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          //pfp, name, subject
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 5, top: 10),
            child: Row(
              children:
              [
                CircleAvatar(backgroundImage: NetworkImage(pfp), radius: 20,),
                SizedBox(width: 10,),
                Text(authorName.toString(), style: TextStyle(fontSize: 18, color: Colors.grey[300]),),
                Spacer(),
                ConstrainedBox
                (
                  constraints: BoxConstraints(maxWidth: 100,),
                  child: Text(subjectName, style: TextStyle(color: Colors.grey[300]),maxLines: 1, overflow: TextOverflow.ellipsis, textWidthBasis: TextWidthBasis.longestLine,),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                Text(description, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                Spacer(),
                Text(type, style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          //Link Icon, Link Content preview, accept, decline
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Icon(Icons.link, color: Colors.white),
                  SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth - 140, // Subtract extra pixels from the remaining width
                    ),
                    child: Text(
                      link,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(), // Pushes the buttons to the end of the row
                  // Checkmark button
                  MaterialButton(
                    onPressed: () {
                      // Add action for checkmark button
                    },
                    shape: CircleBorder(), // Circular button
                    child: Icon(Icons.check, color: Colors.green,), // Checkmark icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: EdgeInsets.all(8), // Padding for icon
                  ),
                  // X button
                  MaterialButton(
                    onPressed: () {
                      // Add action for X button
                    },
                    shape: CircleBorder(), // Circular button
                    child: Icon(Icons.close, color: Colors.red,), // X icon
                    minWidth: 0, // Reduce min width to make it smaller
                    padding: EdgeInsets.all(8), // Padding for icon
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
