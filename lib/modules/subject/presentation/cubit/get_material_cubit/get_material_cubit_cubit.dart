import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/modules/subject/presentation/cubit/add_material_cubit/add_material_cubit.dart';
import 'package:meta/meta.dart';
import 'package:string_similarity/string_similarity.dart';

part 'get_material_state.dart';

class GetMaterialCubit extends Cubit<GetMaterialState> {
  GetMaterialCubit(
    this._subjectRepoImp,
  ) : super(GetMaterialCubitInitial());

  final SubjectRepoImp _subjectRepoImp;

  static GetMaterialCubit get(context) => BlocProvider.of(context);
  List<MaterialModel>? materials;
  List<MaterialModel>? videos;

  List<MaterialModel>? documents;
  List<MaterialModel>? filteredMaterials;

  Future<void> getMaterials({String? subject}) async {
    emit(GetMaterialLoading());

    try {
      materials = await _subjectRepoImp.getMaterials(subject: subject);
      videos = [];
      documents = [];
      filteredMaterials = materials!.reversed.toList();

      emit(GetMaterialSuccess());
      filterVideosAndDocuments();
    } catch (error) {
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
}
