import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/subject/model/subject_model.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/utilities/dio.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(Material1Initial());

  List<SubjectModel> materials = [];
  void getMaterials() {
    emit(GetMaterialLoading());
    DioHelp.getData(
        path: MATERIAL,
        query: {'subject': 'CALC_1', 'accepted': true}).then((response) {
      materials = [];
      response.data.forEach((e) {
        materials.add(SubjectModel.fromJson(e));
      });
      emit(GetMaterialLoaded(materials: materials));
    }).catchError((error) {
      emit(GetMaterialError(errorMessage: error.toString()));
    });
  }

  SubjectModel? materialModel;
  void addMaterial(
      {required String title,
      required String description,
      required String link,
      required String type}) {
    emit(SaveMaterialLoading());

    DioHelp.postData(
      path: MATERIAL,
      data: {
        'subject': 'CALC_1',
        'title': title,
        'description': description,
        'link': link,
        'type': type,
        'semester': 'One',
      },
    ).then((response) {
      emit(SaveMaterialSuccess(material: materialModel!));
    }).catchError((error) {
      if (error is DioException) {
        print('Error: ${error.response?.statusCode} - ${error.response?.data}');
      }
      emit(GetMaterialError(errorMessage: error.toString()));
    });
  }
}
