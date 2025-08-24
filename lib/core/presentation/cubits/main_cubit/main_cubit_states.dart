import 'package:lol/core/models/current_user/current_user_model.dart';

abstract class MainCubitStates {}

final class InitialMainState extends MainCubitStates {}

final class OpenDrawerState extends MainCubitStates {}

final class CloseDrawerState extends MainCubitStates {}

final class ChangeMode extends MainCubitStates {}

final class GetAnnouncementImageSuccess extends MainCubitStates {}

final class GetAnnouncementLimitExceed extends MainCubitStates {}

final class GetAnnouncementImageFailure extends MainCubitStates {}

final class GetAnnouncementImageLoading extends MainCubitStates {}

final class GetProfileLoading extends MainCubitStates {}

final class GetProfileSuccess extends MainCubitStates {}

final class GetProfileFailure extends MainCubitStates {}

final class RetrieveCurrentUserDataLoadingState extends MainCubitStates {}

final class RetrieveCurrentUserDataSuccessState extends MainCubitStates {}

final class RetrieveCurrentUserDataErrorState extends MainCubitStates {
  final String error;
  RetrieveCurrentUserDataErrorState({required this.error});
}

final class GetRequestsLoadingState extends MainCubitStates {}

final class GetRequestsSuccessState extends MainCubitStates {}

final class GetRequestsErrorState extends MainCubitStates {}

final class GetMaterialLoadingState extends MainCubitStates {}

final class GetMaterialSuccessState extends MainCubitStates {}

final class GetMaterialErrorState extends MainCubitStates {}

final class DeleteMaterialLoadingState extends MainCubitStates {}

final class DeleteMaterialSuccessState extends MainCubitStates {}

final class DeleteMaterialErrorState extends MainCubitStates {}

final class AcceptRequestLoadingState extends MainCubitStates {}

final class AcceptRequestSuccessState extends MainCubitStates {}

final class AcceptRequestErrorState extends MainCubitStates {}

final class GetLeaderboardLoadingState extends MainCubitStates {}

final class GetLeaderboardSuccessState extends MainCubitStates {}

final class GetLeaderboardErrorState extends MainCubitStates {}

final class UpdateUserSuccessState extends MainCubitStates {}

final class UpdateUserErrorState extends MainCubitStates {}

final class DeleteimageSuccessState extends MainCubitStates {}

class DeleteimageErrorState extends MainCubitStates {}

final class ChangeAppModeState extends MainCubitStates {}

final class LogoutSuccess extends MainCubitStates {}

final class LogoutFailed extends MainCubitStates {
  final String errMessage;

  LogoutFailed({required this.errMessage});
}

final class DeleteAccountLoading extends MainCubitStates {}

final class DeleteAccountFailed extends MainCubitStates {
  final String errMessage;

  DeleteAccountFailed({required this.errMessage});
}

final class DeleteAccountSuccess extends MainCubitStates {}

final class SendingReportOrFeedBackSuccessState extends MainCubitStates {}

final class SendingReportOrFeedBackErrorState extends MainCubitStates {}

final class GetPreviousExamsLoadingState extends MainCubitStates {}

final class GetPreviousExamsSuccessState extends MainCubitStates {}

final class GetPreviousExamsErrorState extends MainCubitStates {}

final class DeletePreviousExamsLoadingState extends MainCubitStates {}

final class DeletePreviousExamsSuccessState extends MainCubitStates {}

final class DeletePreviousExamsErrorState extends MainCubitStates {}

final class AddPreviousExamsLoadingState extends MainCubitStates {}

final class AddPreviousExamsSuccessState extends MainCubitStates {}

final class AddPreviousExamsErrorState extends MainCubitStates {}

final class EditPreviousExamsLoadingState extends MainCubitStates {}

final class EditPreviousExamsSuccessState extends MainCubitStates {}

final class EditPreviousExamsErrorState extends MainCubitStates {}

final class ChangeBottomSheetState extends MainCubitStates {}
