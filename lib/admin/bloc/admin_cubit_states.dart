import 'package:lol/admin/model/announcement_model.dart';

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

class AdminSaveAnnouncementSuccessState extends AdminCubitStates{
  final AnnouncementModel announcementModel;

  AdminSaveAnnouncementSuccessState(this.announcementModel);
}

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