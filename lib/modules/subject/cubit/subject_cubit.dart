import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:string_similarity/string_similarity.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(MaterialInitial());

  static SubjectCubit get(context) => BlocProvider.of(context);

  List<MaterialModel>? materials;
  List<MaterialModel>? videos;
  int index = 0;
  List<MaterialModel>? documents;
  List<MaterialModel>? filteredMaterials;

  void runFilter({required String query}) {
    filteredMaterials = [];
    if (query.isEmpty) {
      filteredMaterials = materials!;
    } else {
      for (var material in materials!) {
        if (material.title!.toLowerCase().contains(query.toLowerCase()) ||
            material.title!.similarityTo(query) > 0.1 ||
            material.description!.toLowerCase().contains(query.toLowerCase()) ||
            material.description!.similarityTo(query) > 0.1) {
          filteredMaterials!.add(material);
        }
      }
      // sort filteredMaterials according to how well each material matches the search query
      filteredMaterials!.sort((a, b) {
        double scoreA = a.title!.similarityTo(query);
        double scoreB = b.title!.similarityTo(query);
        return scoreB.compareTo(scoreA);
      });
    }
    print(filteredMaterials);
    filterVideosAndDocuments();
    emit(GetMaterialLoaded(materials: filteredMaterials!));
  }

  void getMaterials() {
    emit(GetMaterialLoading());

    try {
      DioHelp.getData(
          path: MATERIAL,
          query: {'subject': 'CALC_1', 'accepted': true}).then((response) {
        materials = [];
        videos = [];
        documents = [];
        index = 0;

        response.data.forEach((e) {
          materials!.add(MaterialModel.fromJson(e));
        });
        filteredMaterials = materials;
        filterVideosAndDocuments();

        emit(GetMaterialLoaded(materials: filteredMaterials!));
      });
    } catch (e) {
      print('error =============> $e');
    }
  }

  void filterVideosAndDocuments() {
    videos = filteredMaterials!
        .where((material) => material.type == 'VIDEO')
        .toList();
    documents = filteredMaterials!
        .where((material) => material.type == 'DOCUMENT')
        .toList();
  }

  void addMaterial(
      {required String title,
      String description = '',
      required String link,
      required String type,
      required String semester,
      required String subjectName}) {
    emit(SaveMaterialLoading());

    DioHelp.postData(
      path: MATERIAL,
      data: {
        'subject': subjectName,
        'title': title,
        'description': description,
        'link': link,
        'type': type,
        'semester': semester,
      },
      token: TOKEN,
    ).then((response) {
      getMaterials();
      emit(SaveMaterialSuccess());
    });
  }

  void deleteMaterial({required MaterialModel material}) {
    emit(DeleteMaterialLoading());
    DioHelp.deleteData(
      path: MATERIAL,
      token: TOKEN,
    ).then((response) {
      getMaterials();
      emit(DeleteMaterialSuccess(material: material));
    });
  }

  int selectedTabIndex = 0;
  void changeTap({required int index}) {
    selectedTabIndex = index;
    emit(TabChangedState(selectedIndex: selectedTabIndex));
  }

  String item1 = 'VIDEO';
  String item2 = 'DOCUMENT';
  String selectedType = 'VIDEO';

  void changeType({required String type}) {
    selectedType = type;
    emit(TypeChangedState(selectedType: selectedType));
  }
}
