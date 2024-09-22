import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/material/model/material_model.dart' as material_model;
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/utilities/dio.dart';

part 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit() : super(Material1Initial());

  List<material_model.MaterialModel> materials = [];
  void getMaterials() {
    emit(GetMaterialLoading());
    DioHelp.getData(path: MATERIAL).then((material) {
      materials = [];
      material.data.ForEach((e) {
        materials.add(material_model.MaterialModel.fromJson(e));
      });
    });
    emit(GetMaterialLoaded(materials: materials));
  }

  material_model.MaterialModel? materialModel;
  void addMaterial(
      {required String title,
      required String description,
      required String link,
      required MaterialType type}) {
    emit(SaveMaterialLoading());
    DioHelp.postData(path: MATERIAL, data: {
      'title': title,
      'description': description,
      'link': link,
      'type': type
    }); //not finished yet
  }
}
