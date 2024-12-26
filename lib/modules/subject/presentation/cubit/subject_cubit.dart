import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/models/fcm_model.dart';
import 'package:lol/models/subjects/subject_model.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/modules/subject/data/repos/subject_repo.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:string_similarity/string_similarity.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit(this._subjectRepo, {required this.adminCubit})
      : super(MaterialInitial());
  final SubjectRepo _subjectRepo;

  static SubjectCubit get(context) => BlocProvider.of(context);
  final AdminCubit adminCubit;
  List<MaterialModel>? materials;
  List<MaterialModel>? videos;

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
    emit(GetMaterialSuccess(materials: filteredMaterials!));
    filterVideosAndDocuments();
  }

  Future<void> getMaterials({String? subject}) async {
    emit(GetMaterialLoading());

    try {
      materials = await _subjectRepo.getMaterials(subject: subject);
      videos = [];
      documents = [];
      filteredMaterials = materials!.reversed.toList();

      emit(GetMaterialSuccess(materials: filteredMaterials!));
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

  List<FcmToken> get adminFCMTokens => adminCubit.adminFcmTokens;
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
  void addMaterial(
      {required String title,
      String description = '',
      required String link,
      required String type,
      required String semester,
      required String subjectName,
      required String role,
      required AuthorModel author}) async {
    await adminCubit.getFcmTokens();
    Random random = Random();

    // Get a random index
    int randomIndex = random.nextInt(notificationsMaterialTitle.length);
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
        'author': {'name': author.authorName, 'photo': author.authorPhoto}
      },
      token: TOKEN,
    ).then((response) {
      if (role == 'ADMIN') {
        emit(SaveMaterialSuccessAdmin());
      } else {
        adminCubit.sendNotificationToUsers(
            sendToAdmin: true,
            semester: semester,
            title: notificationsMaterialTitle[randomIndex],
            body:
                "${author.authorName} wants to add a material in ${subjectName.replaceAll('_', " ").replaceAll("and", "&")} !");

        emit(SaveMaterialSuccessUser());
      }

      getMaterials(subject: subjectName);
    }).catchError(
        // ignore: invalid_return_type_for_catch_error
        (e) => print('Error from posting material =/////////////////$e'));
  }

  void deleteMaterial({required String subjectName, required int id}) {
    emit(DeleteMaterialLoading());
    DioHelp.deleteData(path: MATERIAL, token: TOKEN, data: {'id': id})
        .then((response) {
      getMaterials(subject: subjectName);
      emit(DeleteMaterialSuccess());
    });
  }

  // int selectedTabIndex = 0;
  // void changeTap({required int index}) {
  //   selectedTabIndex = index;
  //   emit(TabChangedState(selectedIndex: selectedTabIndex));
  // }

  String item1 = 'VIDEO';
  String item2 = 'DOCUMENT';
  String selectedType = 'VIDEO';

  void changeType({required String type}) {
    selectedType = type;
    emit(TypeChangedState(selectedType: selectedType));
  }
}
