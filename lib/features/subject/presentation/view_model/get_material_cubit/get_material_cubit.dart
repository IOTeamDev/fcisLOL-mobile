import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/features/subject/presentation/view_model/add_material_cubit/add_material_cubit.dart';
import 'package:meta/meta.dart';
import 'package:string_similarity/string_similarity.dart';

part 'get_material_state.dart';

class GetMaterialCubit extends Cubit<GetMaterialState> {
  GetMaterialCubit(
    this._subjectRepoImp,
  ) : super(GetMaterialInitial());

  final SubjectRepoImp _subjectRepoImp;
  String subjectName = '';

  static GetMaterialCubit get(context) => BlocProvider.of(context);
  List<MaterialModel>? materials;
  List<MaterialModel>? videos;

  List<MaterialModel>? documents;
  List<MaterialModel>? filteredMaterials;

  Future<void> getMaterials({String? subject}) async {
    if (isClosed) return;

    emit(GetMaterialLoading());

    try {
      materials = await _subjectRepoImp.getMaterials(subject: subject);
      if (isClosed) return;
      videos = [];
      documents = [];
      filteredMaterials = materials!.reversed.toList();
      emit(GetMaterialSuccess());
      filterVideosAndDocuments();
    } catch (error) {
      if (isClosed) return;

      log('error from getting materials $error');
      emit(GetMaterialError(errorMessage: error.toString()));
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
    emit(GetMaterialSuccess());
    filterVideosAndDocuments();
  }

  void deleteMaterial({required String subjectName, required int id}) {
    emit(DeleteMaterialLoading());
    DioHelp.deleteData(
        path: MATERIAL,
        token: AppConstants.TOKEN,
        data: {'id': id}).then((response) {
      emit(DeleteMaterialSuccess());
      getMaterials(subject: subjectName);
    }).catchError((error) {
      log('error from deleting material $error');
      emit(DeleteMaterialError(error: error.toString()));
    });
  }
}
