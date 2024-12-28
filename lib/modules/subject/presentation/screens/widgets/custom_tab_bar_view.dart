import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/modules/subject/presentation/cubit/subject_cubit.dart';
import 'package:lol/modules/subject/presentation/screens/widgets/documents_card.dart';
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
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            var cubit = SubjectCubit.get(context);
            return ConditionalBuilder(
                condition:
                    state is! GetMaterialLoading && cubit.documents!.isNotEmpty,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: cubit.documents!.length,
                      itemBuilder: (context, i) {
                        return DocumentsCard(document: cubit.documents![i]);
                      },
                    ),
                  );
                },
                fallback: (context) {
                  if (state is GetMaterialLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: isDark ? Colors.white : Colors.black),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Materials Appear here',
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                    );
                  }
                });
          },
        ),
      ],
    );
  }
}
