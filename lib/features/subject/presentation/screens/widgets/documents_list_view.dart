import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';

import 'package:lol/features/subject/presentation/screens/widgets/documents_card.dart';
import 'package:provider/provider.dart';

import '../../../../../core/presentation/cubits/main_cubit/main_cubit.dart';

class DocumentsListView extends StatelessWidget {
  const DocumentsListView({
    super.key,
  });

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
                color: Provider.of<ThemeProvider>(context).isDark
                    ? ColorsManager.white
                    : ColorsManager.black),
          );
        } else if (state is GetMaterialSuccess) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: cubit.documents!.length,
              itemBuilder: (context, i) {
                if (cubit.documents!.isEmpty) {
                  return Center(
                    child: Text('Materials Apper here'),
                  );
                } else {
                  return DocumentsCard(document: cubit.documents![i]);
                }
              },
            ),
          );
        } else if (state is GetMaterialError) {
          return Center(
            child: Text(
              'Oops! Something went wrong',
              style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDark
                      ? ColorsManager.white
                      : ColorsManager.black),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
