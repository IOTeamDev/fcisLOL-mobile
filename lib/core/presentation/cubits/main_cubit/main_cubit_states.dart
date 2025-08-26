import 'package:lol/core/models/current_user/current_user_model.dart';

abstract class MainState {}

final class InitialMainState extends MainState {}

final class OpenDrawerState extends MainState {}

final class CloseDrawerState extends MainState {}

final class ChangeMode extends MainState {}

final class GetAnnouncementImageSuccess extends MainState {}

final class GetAnnouncementLimitExceed extends MainState {}

final class GetAnnouncementImageFailure extends MainState {}

final class GetAnnouncementImageLoading extends MainState {}

final class GetProfileLoading extends MainState {}

final class GetProfileSuccess extends MainState {}

final class GetProfileFailure extends MainState {}

final class RetrieveCurrentUserDataLoadingState extends MainState {}

final class RetrieveCurrentUserDataSuccessState extends MainState {}

final class RetrieveCurrentUserDataErrorState extends MainState {
  final String error;
  RetrieveCurrentUserDataErrorState({required this.error});
}

final class GetRequestsLoadingState extends MainState {}

final class GetRequestsSuccessState extends MainState {}

final class GetRequestsErrorState extends MainState {}

final class GetMaterialLoadingState extends MainState {}

final class GetMaterialSuccessState extends MainState {}

final class GetMaterialErrorState extends MainState {}

final class DeleteMaterialLoadingState extends MainState {}

final class DeleteMaterialSuccessState extends MainState {}

final class DeleteMaterialErrorState extends MainState {}

final class AcceptRequestLoadingState extends MainState {}

final class AcceptRequestSuccessState extends MainState {}

final class AcceptRequestErrorState extends MainState {}

final class GetLeaderboardLoadingState extends MainState {}

final class GetLeaderboardSuccessState extends MainState {}

final class GetLeaderboardErrorState extends MainState {}

final class UpdateUserSuccessState extends MainState {}

final class UpdateUserErrorState extends MainState {}

final class DeleteimageSuccessState extends MainState {}

class DeleteimageErrorState extends MainState {}

final class ChangeAppModeState extends MainState {}

final class LogoutSuccess extends MainState {}

final class LogoutFailed extends MainState {
  final String errMessage;

  LogoutFailed({required this.errMessage});
}

final class DeleteAccountLoading extends MainState {}

final class DeleteAccountFailed extends MainState {
  final String errMessage;

  DeleteAccountFailed({required this.errMessage});
}

final class DeleteAccountSuccess extends MainState {}

final class SendingReportOrFeedBackSuccessState extends MainState {}

final class SendingReportOrFeedBackErrorState extends MainState {}

final class GetPreviousExamsLoadingState extends MainState {}

final class GetPreviousExamsSuccessState extends MainState {}

final class GetPreviousExamsErrorState extends MainState {}

final class DeletePreviousExamsLoadingState extends MainState {}

final class DeletePreviousExamsSuccessState extends MainState {}

final class DeletePreviousExamsErrorState extends MainState {}

final class AddPreviousExamsLoadingState extends MainState {}

final class AddPreviousExamsSuccessState extends MainState {}

final class AddPreviousExamsErrorState extends MainState {}

final class EditPreviousExamsLoadingState extends MainState {}

final class EditPreviousExamsSuccessState extends MainState {}

final class EditPreviousExamsErrorState extends MainState {}

final class ChangeBottomSheetState extends MainState {}
