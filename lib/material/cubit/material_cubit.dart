import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/material/model/material_model.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/utilities/dio.dart';

part 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit() : super(Material1Initial());

  List<MaterialModel> materials = [];
  void getMaterials() {
    emit(GetMaterialLoading());
    DioHelp.getData(path: MATERIAL).then((material) {
      materials = [];
      material.data.ForEach((e) {
        materials.add(MaterialModel.fromJson(e));
      });
    });
    emit(GetMaterialLoaded(materials: materials));
  }
}
