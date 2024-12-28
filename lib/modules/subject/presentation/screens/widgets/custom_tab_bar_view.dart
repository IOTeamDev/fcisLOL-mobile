import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/subject/presentation/cubit/subject_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/documents_card.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/documents_list_view.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/grid_tile_widget.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/videos_list_view.dart';

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        VideosListView(),
        DocumentsListView(),
      ],
    );
  }
}
