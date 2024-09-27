import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/models/current_user/current_user_model.dart';
import 'package:lol/models/leaderboard/leaderboard_model.dart';
import 'package:lol/modules/auth/bloc/login_cubit.dart';
import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/models/login/login_model.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/layout/home/bloc/main_cubit_states.dart';
import 'package:lol/models/profile/profile_model.dart';
import 'package:lol/modules/year_choose/choosing_year.dart';
import 'package:lol/layout/home/home.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:lol/shared/components/navigation.dart';
import 'package:lol/shared/network/local/shared_prefrence.dart';

//uid null?
class MainCubit extends Cubit<MainCubitStates> {
  MainCubit() : super(InitialMainState());
  static MainCubit get(context) => BlocProvider.of(context);

  bool opendedDrawer = false;
  void openDrawerState() {
    opendedDrawer = true;
    emit(OpenDrawerState());
  }  void closeDrawerState() {
    opendedDrawer = false;
    emit(CloseDrawerState());
  }

  bool isDarkMode = false;
  void changeMode() {
    isDarkMode = !isDarkMode;
    emit(ChangeMode());
  }

  File? userImageFile;
  String? userImagePath;
  var picker = ImagePicker();

  getUserImage({required bool fromGallery}) async {
    emit(GetUserImageLoading());

    var tempPostImage = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (tempPostImage != null) {
      userImageFile = File(tempPostImage.path);
      emit(GetUserImageSuccess());
      userImagePath = await UploadPImage(image: userImageFile!);
    } else {
      emit(GetUserImageFailure());
    }
  }

  Future<String?> UploadPImage({required File image}) async {
    emit(UploadImageLoading());

    final uploadTask = await FirebaseStorage.instance
        .ref()
        .child("images/${Uri.file(image.path).pathSegments.last}")
        .putFile(image);

    try {
      final imagePath = await uploadTask.ref.getDownloadURL();
      emit(UploadImageSuccess());
      return imagePath;
    } on Exception {
      emit(UploadImageFailure());
      // // TODO
    }
    return null;
  }

  ProfileModel? profileModel;
  getProfileInfo() {
    emit(GetProfileLoading());
    profileModel = null;

    DioHelp.getData(path: CURRENTUSER, token: TOKEN).then(
      (value) {
        profileModel = ProfileModel.fromJson(value.data);
        emit(GetProfileSuccess());
      },
    );
  }

  void logout(context) {
    TOKEN = null;
    Cache.removeValue(key: "token");
    navigatReplace(
        context,
        ChoosingYear(
          loginCubit: LoginCubit(),
        ));
    emit(Logout());
  }
}
