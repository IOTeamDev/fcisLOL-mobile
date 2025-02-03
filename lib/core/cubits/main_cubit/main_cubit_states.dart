import 'package:lol/core/models/current_user/current_user_model.dart';

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

class GetUserImageLimitExceed extends MainCubitStates {}

class GetUserImageNoMoreSpace extends MainCubitStates {}

class UploadImageSuccess extends MainCubitStates {}

class UploadImageFailure extends MainCubitStates {}

class UploadImageLoading extends MainCubitStates {}

class GetProfileLoading extends MainCubitStates {}

class GetProfileSuccess extends MainCubitStates {}

class GetProfileFailure extends MainCubitStates {}

class Logout extends MainCubitStates {}

class RetrieveCurrentUserDataLoadingState extends MainCubitStates {}

class RetrieveCurrentUserDataSuccessState extends MainCubitStates {}

class RetrieveCurrentUserDataErrorState extends MainCubitStates {
  final String error;
  RetrieveCurrentUserDataErrorState({required this.error});
}

class GetRequestsLoadingState extends MainCubitStates {}

class GetRequestsSuccessState extends MainCubitStates {}

class GetRequestsErrorState extends MainCubitStates {}

class GetMaterialLoadingState extends MainCubitStates {}

class GetMaterialSuccessState extends MainCubitStates {}

class GetMaterialErrorState extends MainCubitStates {}

class DeleteMaterialLoadingState extends MainCubitStates {}

class DeleteMaterialSuccessState extends MainCubitStates {}

class DeleteMaterialErrorState extends MainCubitStates {}

class AcceptRequestLoadingState extends MainCubitStates {}

class AcceptRequestSuccessState extends MainCubitStates {}

class AcceptRequestErrorState extends MainCubitStates {}

class GetLeaderboardLoadingState extends MainCubitStates {}

class GetLeaderboardSuccessState extends MainCubitStates {}

class GetLeaderboardErrorState extends MainCubitStates {}

class GetAnnouncementsLoadingState extends MainCubitStates {}

class GetAnnouncementsSuccessState extends MainCubitStates {}

class GetAnnouncementsErrorState extends MainCubitStates {}

class UpdateAnnouncementsLoadingState extends MainCubitStates {}

class UpdateAnnouncementsSuccessState extends MainCubitStates {}

class UpdateAnnouncementsErrorState extends MainCubitStates {}

class UpdateUserSuccessState extends MainCubitStates {}

class UpdateUserErrorState extends MainCubitStates {}

class DeleteimageSuccessState extends MainCubitStates {}

class DeleteimageErrorState extends MainCubitStates {}

class ChangeAppModeState extends MainCubitStates {}
