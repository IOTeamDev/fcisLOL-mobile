import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/models/fcm_model.dart';
import 'package:lol/core/utils/resources/strings_manager.dart';
import 'package:lol/features/subject/data/models/author_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
part 'add_material_state.dart';

class AddMaterialCubit extends Cubit<AddMaterialState> {
  AddMaterialCubit() : super(AddMaterialInitial());

  static AddMaterialCubit get(context) => BlocProvider.of(context);

  Future<void> addMaterial(
      {required String title,
      String description = '',
      required String link,
      required String type,
      required String semester,
      required String subjectName,
      required String role,
      required AuthorModel author}) async {
    // Get a random index

    emit(AddMaterialLoading());
    try {
      final response = await DioHelp.postData(
        path: MATERIAL,
        data: {
          'subject': subjectName,
          'title': title,
          'description': description,
          'link': link,
          'type': type,
          'semester': semester,
          'author': {'name': author.authorName, 'photo': author.authorPhoto}
        },
        token: AppConstants.TOKEN,
      );
      if (role == KeysManager.admin || role == KeysManager.developer) {
        emit(AddMaterialSuccessAdmin(materialId: response.data['id']));
      } else {
        emit(AddMaterialSuccessUser());
      }
    } catch (e) {
      log('Error from posting material =/////////////////$e');
      emit(AddMaterialFailed(errorMessage: e.toString()));
    }
  }

  List<String> notificationsMaterialTitle = [
    "New Material! Check It Out, 🚀",
    "User Shared Content! Approve? 🎉",
    "Fresh Content! Give It the Green Light, 🌟",
    "Submission Pending Your Approval, 👍",
    "Exciting Update! Ready to Review?,",
    "User Submission! Time to Shine, 🌈",
    "New Content! Help It Grow, 🌱",
    "Awesome Upload! Approve?, 💪",
    "Fresh Upload! Tap to Approve, ✨",
    "Your Review Needed! Check It Out, 💼",
  ];

  final String item1 = 'VIDEO';
  final String item2 = 'DOCUMENT';
  String selectedType = 'VIDEO';

  void changeType({required String type}) {
    selectedType = type;
    emit(TypeChangedState(selectedType: selectedType));
  }

  Future<void> editMaterial({
    required int id,
    required String title,
    String description = '',
    required String link,
  }) async {
    emit(EditMaterialLoading());

    try {
      await DioHelp.patchData(
        path: EDITMATERIAL,
        data: {
          'id': id,
          'title': title,
          'description': description,
          'link': link,
        },
        token: AppConstants.TOKEN,
      );
      emit(EditMaterialSuccess());
    } catch (e) {
      debugPrint('Error from editting material =/////////////////$e');
      emit(EditMaterialFailed(errorMessage: e.toString()));
    }
  }
}
