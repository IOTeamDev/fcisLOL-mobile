import 'package:lol/models/current_user/current_user_model.dart';

abstract class MainCubitStates {}

class InitialMainState extends MainCubitStates {}

class OpenDrawerState extends MainCubitStates {}

class CloseDrawerState extends MainCubitStates {}

class ChangeMode extends MainCubitStates {}

class GetUserImageSuccess extends MainCubitStates {}

class GetUserImageFailure extends MainCubitStates {}

class GetUserImageLoading extends MainCubitStates {}

class GetAnnouncementImageSuccess extends MainCubitStates {}

class GetAnnouncementLimitExceed extends MainCubitStates {}

class GetAnnouncementImageFailure extends MainCubitStates {}

class GetAnnouncementImageLoading extends MainCubitStates {}

class GetUserImageLimitExceed extends MainCubitStates{}

class UploadImageSuccess extends MainCubitStates {}

class UploadImageFailure extends MainCubitStates {}

class UploadImageLoading extends MainCubitStates {}

class GetProfileLoading extends MainCubitStates{}

class GetProfileSuccess extends MainCubitStates{}

class GetProfileFailure extends MainCubitStates{}

class Logout extends MainCubitStates{}

class RetrieveCurrentUserDataLoadingState extends MainCubitStates{}

class RetrieveCurrentUserDataSuccessState extends MainCubitStates{
}

class RetrieveCurrentUserDataErrorState extends MainCubitStates{
  final String error;
  RetrieveCurrentUserDataErrorState({required this.error});
}

class GetRequestsLoadingState extends MainCubitStates{}

class GetRequestsSuccessState extends MainCubitStates{}

class GetRequestsErrorState extends MainCubitStates{}

class DeleteMaterialLoadingState extends MainCubitStates{}

class DeleteMaterialSuccessState extends MainCubitStates{}

class DeleteMaterialErrorState extends MainCubitStates{}

class AcceptRequestLoadingState extends MainCubitStates{}

class AcceptRequestSuccessState extends MainCubitStates{}

class AcceptRequestErrorState extends MainCubitStates{}

class GetLeaderboardLoadingState extends MainCubitStates{}

class GetLeaderboardSuccessState extends MainCubitStates{}

class GetLeaderboardErrorState extends MainCubitStates{}
