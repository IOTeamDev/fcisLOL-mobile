import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(Material1Initial());

  static SubjectCubit get(context) => BlocProvider.of(context);

  List<SubjectModel>? materials;
  List<SubjectModel>? videos;
  int index = 0;
  List<SubjectModel>? documents;
  void getMaterials() {
    emit(GetMaterialLoading());
    DioHelp.getData(
        path: MATERIAL,
        query: {'subject': 'CALC_1', 'accepted': true}).then((response) {
      print(response.data);
      materials = [];
      videos = [];
      index = 0;
      documents = [];
      response.data.forEach((e) {

        materials!.add(SubjectModel.fromJson(e));
        if(materials![index].type == 'VIDEO')
          {
            videos!.add(materials![index]);
          }
        else
          {
            documents!.add(materials![index]);
          }
          index++;
      });

      print(materials![0].title.toString());
      emit(GetMaterialLoaded(materials: materials!));
    });
  }


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
      token: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjIzLCJpYXQiOjE3MjcxMTE2MzEsImV4cCI6MTc1ODIxNTYzMX0.PUT9eFsFd4Bo-5ulhxFQu3T1HmYXza31Vo-C7lz2Nzg',
    ).then((response) {
      print(response.data);
      getMaterials();
      emit(SaveMaterialSuccess());
    });
  }
}
