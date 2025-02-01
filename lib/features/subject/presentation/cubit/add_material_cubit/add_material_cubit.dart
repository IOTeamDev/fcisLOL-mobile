import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/models/fcm_model.dart';
import 'package:lol/features/subject/data/models/author_model.dart';
import 'package:lol/features/subject/data/models/material_model.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/subject/data/repos/subject_repo_imp.dart';
import 'package:lol/core/utils/constants.dart';
import 'package:lol/core/network/endpoints.dart';
import 'package:lol/core/network/remote/dio.dart';
import 'package:meta/meta.dart';
part 'add_material_state.dart';

class AddMaterialCubit extends Cubit<AddMaterialState> {
  AddMaterialCubit(this.adminCubit) : super(AddMaterialInitial());

  // final SubjectRepoImp _subjectRepoImp;
  final AdminCubit adminCubit;

  static AddMaterialCubit get(context) => BlocProvider.of(context);

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
    emit(AddMaterialLoading());

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
        emit(AddMaterialSuccessAdmin());
      } else {
        adminCubit.sendNotificationToUsers(
            sendToAdmin: true,
            semester: semester,
            title: notificationsMaterialTitle[randomIndex],
            body:
                "${author.authorName} wants to add a material in ${subjectName.replaceAll('_', " ").replaceAll("and", "&")} !");

        emit(AddMaterialSuccessUser());
      }

      // getMaterials(subject: subjectName);
    }).catchError(
        // ignore: invalid_return_type_for_catch_error
        (e) => print('Error from posting material =/////////////////$e'));
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

  final String item1 = 'VIDEO';
  final String item2 = 'DOCUMENT';
  String selectedType = 'VIDEO';

  void changeType({required String type}) {
    selectedType = type;
    emit(TypeChangedState(selectedType: selectedType));
  }
}
