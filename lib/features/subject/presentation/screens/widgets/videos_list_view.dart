import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/grid_tile_widget.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';

class VideosListView extends StatelessWidget {
  const VideosListView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = GetMaterialCubit.get(context);
    return BlocBuilder<GetMaterialCubit, GetMaterialState>(
      buildWhen: (previous, current) =>
          current is GetMaterialLoading ||
          current is GetMaterialSuccess ||
          current is GetMaterialError,
      builder: (context, state) {
        if (state is GetMaterialLoading) {
          return Center(
            child: CircularProgressIndicator(
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
          );
        } else if (state is GetMaterialSuccess) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: cubit.videos!.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MainCubit.get(context).isDark
                        ? Color.fromRGBO(59, 59, 59, 1)
                        : HexColor('#4764C5'),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GridTileWidget(video: cubit.videos![i]),
                );
              },
            ),
          );
        } else if (state is GetMaterialError) {
          return Center(
            child: Text(
              'Oops! Something went wrong',
              style: TextStyle(
                  color: MainCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
