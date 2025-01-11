import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/modules/subject/presentation/cubit/delete_material_cubit/delete_material_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/documents_list_view.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/videos_list_view.dart';

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteMaterialCubit(),
      child: TabBarView(
        controller: controller,
        children: [
          VideosListView(),
          DocumentsListView(),
        ],
      ),
    );
  }
}
