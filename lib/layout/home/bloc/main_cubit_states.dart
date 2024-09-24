import 'package:lol/models/current_user/current_user_model.dart';

abstract class MainCubitStates {}

class InitialMainState extends MainCubitStates {}

class ChangeMode extends MainCubitStates {}

class GetUserImageSuccess extends MainCubitStates {}

class GetUserImageFailure extends MainCubitStates {}

class GetUserImageLoading extends MainCubitStates {}

class UploadImageSuccess extends MainCubitStates {}

class UploadImageFailure extends MainCubitStates {}

class UploadImageLoading extends MainCubitStates {}

class GetProfileLoading extends MainCubitStates{}

class GetProfileSuccess extends MainCubitStates{}

class GetProfileFailure extends MainCubitStates{}

class Logout extends MainCubitStates{}

class RetrieveCurrentUserDataLoadingState extends MainCubitStates{}

class RetrieveCurrentUserDataSuccessState extends MainCubitStates{
  CurrentUserModel userModel;
  RetrieveCurrentUserDataSuccessState({required this.userModel});
}

class RetrieveCurrentUserDataErrorState extends MainCubitStates{
  final String error;
  RetrieveCurrentUserDataErrorState({required this.error});
}
