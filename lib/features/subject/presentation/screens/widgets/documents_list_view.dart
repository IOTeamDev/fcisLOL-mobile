import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';

import 'package:lol/features/subject/presentation/screens/widgets/documents_card.dart';

import '../../../../../core/cubits/main_cubit/main_cubit.dart';

class DocumentsListView extends StatelessWidget {
  const DocumentsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = GetMaterialCubit.get(context);
    return BlocBuilder<GetMaterialCubit, GetMaterialState>(
      builder: (context, state) {
        if (state is GetMaterialLoading) {
          return Center(
            child: CircularProgressIndicator(
                color: MainCubit.get(context).isDark ? Colors.white : Colors.black),
          );
        } else if (state is GetMaterialSuccess) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: cubit.documents!.length,
              itemBuilder: (context, i) {
                return DocumentsCard(document: cubit.documents![i]);
              },
            ),
          );
        } else {
          return Center(
            child: Text(
              'Materials Appear here',
              style: TextStyle(color: MainCubit.get(context).isDark ? Colors.white : Colors.black),
            ),
          );
        }
      },
    );
  }
}
