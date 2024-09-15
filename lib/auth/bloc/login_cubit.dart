import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/model/login_model.dart';
import 'package:lol/utilities/dio.dart';

//uid null?
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(Initial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool hiddenPassword = true;

  togglePassword() {
    hiddenPassword = !hiddenPassword;

    emit(TogglePassword());
  }

  // RegisterModel?
  //     registerModel; //maybe delete in the future if it seems that we don't need it

  LoginModel? modelLogin;
  void register({
    required String name,
    required String email,
    required String phone,
    required String photo,
    required String password,
    required String semester,
  }) {
    emit(RegisterLoading());
    DioHelp.postData(path: "users", data: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "photo": photo,
      "semester": semester,
    }).then(
      (value) {
        modelLogin = LoginModel.fromJson(value.data);
        // print(modelLogin!.token);
        emit(RegisterSuccess());
      },
    ).catchError((erro) => emit(RegisterFailed()));
  }

  void login({required email, required password}) async {
    emit(LoginLoading());
    DioHelp.postData(path: "login", data: {
      "email": email,
      "password": password,
    }).then(
      (value) {
        modelLogin = LoginModel.fromJson(value.data);
        print(modelLogin!.token);
        emit(LoginSuccess(token: modelLogin!.token));
      },
    ).catchError((error) {
      emit(LoginFailed());
    });
  }

  var picker = ImagePicker();
  File? profileImage;

  pickProfileImage(bool isCamera) async{
    var tempImage =await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery); 

    if (tempImage != null) {profileImage = File(tempImage.path);
    
    emit(PickImageSuccess());
    
    }
    else

    emit(PickImageFailed());

  }

void uploadProfileImage(){}


  void getData() {}

  // void UpdateData({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String uiD,
  //   required bool isEmailVerified,
  //   required String backgroundImagePath,
  //   required String profileImagePath,

  // }) {
  //   FirebaseFirestore.instance.collection("Users").doc(uID).update();
  // }
}
