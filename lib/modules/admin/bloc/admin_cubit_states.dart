import 'package:lol/models/admin/announcement_model.dart';
import 'package:lol/models/admin/requests_model.dart';

abstract class AdminCubitStates {}




class InitialAdminState extends AdminCubitStates{}

class AdminGetAnnouncementLoadingState extends AdminCubitStates{}

class AdminGetAnnouncementSuccessState extends AdminCubitStates{
  final List<AnnouncementModel> announcements;

  AdminGetAnnouncementSuccessState(this.announcements);
}

class AdminGetAnnouncementsErrorState extends AdminCubitStates{
  final String error;

  AdminGetAnnouncementsErrorState(this.error);
}

class AdminSaveAnnouncementLoadingState extends AdminCubitStates{}

class AdminSaveAnnouncementSuccessState extends AdminCubitStates{}

class AdminSaveAnnouncementsErrorState extends AdminCubitStates{
  final String error;

  AdminSaveAnnouncementsErrorState(this.error);
}

class AdminDeleteAnnouncementLoadingState extends AdminCubitStates{}

class AdminDeleteAnnouncementSuccessState extends AdminCubitStates{}

class AdminDeleteAnnouncementErrorState extends AdminCubitStates{
  final String error;

  AdminDeleteAnnouncementErrorState(this.error);
}

class AdminUpdateAnnouncementLoadingState extends AdminCubitStates{}

class AdminUpdateAnnouncementSuccessState extends AdminCubitStates{}

class AdminUpdateAnnouncementErrorState extends AdminCubitStates{
  final String error;
  AdminUpdateAnnouncementErrorState(this.error);
}

class AdminGetRequestsLoadingState extends AdminCubitStates{}

class AdminGetRequestsSuccessState extends AdminCubitStates{
  final List<RequestsModel> requests;

  AdminGetRequestsSuccessState(this.requests);
}

class AdminGetRequestsErrorState extends AdminCubitStates{
  final String error;

  AdminGetRequestsErrorState(this.error);
}

class AdminDeleteMaterialLoadingState extends AdminCubitStates{}

class AdminDeleteMaterialSuccessState extends AdminCubitStates{}

class AdminDeleteMaterialErrorState extends AdminCubitStates{
  final String error;

  AdminDeleteMaterialErrorState(this.error);
}

class AdminAcceptRequestLoadingState extends AdminCubitStates{}

class AdminAcceptRequestSuccessState extends AdminCubitStates{}

class AdminAcceptRequestErrorState extends AdminCubitStates{
  final String error;

  AdminAcceptRequestErrorState(this.error);
}

class GetFcmTokensSuccess extends AdminCubitStates{}

class GetFcmTokensError extends AdminCubitStates{}
