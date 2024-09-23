import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/material/cubit/material_state.dart';
import 'package:lol/material/model/material_model.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/utilities/dio.dart';
//import 'package:flutter/src/material/material_state.dart';


class MaterialCubit extends Cubit<MaterialCubitState> {
  MaterialCubit() : super(Material1Initial());

  List<MaterialModel> materials = [];
  void getMaterials() {
    emit(GetMaterialLoading());
    DioHelp.getData(
      path: MATERIAL,
      query: {'subject': 'CALC_1', 'accepted': true}).then((material) {
        materials = [];
        print(material.data);
        material.data.forEach((e) {
          materials.add(MaterialModel.fromJson(e));
        });
    });
    emit(GetMaterialLoaded(materials: materials));
  }

  MaterialModel? materialModel;
  void addMaterial(
      {required String title,
      required String description,
      required String link,
      required String type}) {
    emit(SaveMaterialLoading());
    DioHelp.postData(path: MATERIAL, data: {
      'subject': 'CALC_1',
      'title': title,
      'description': description,
      'link': link,
      'type': type,
      'semester': 'One'
    }); //not finished yet
  }
}
