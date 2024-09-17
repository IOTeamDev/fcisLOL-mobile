import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/admin/model/announcement_model.dart';
import 'package:lol/admin/screens/Announcements/add_announcement.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/model/login_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/utilities/dio.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);



  AnnouncementModel? announcementModel;
  void addAnnouncement({required title, description, required dueDate, required type})
  {
    emit(AdminSaveAnnouncementLoadingState());
    DioHelp.postData(
      path: ANNOUNCEMENTS,
      data: {'title':title, 'content':description??'', 'due_date':dueDate, 'type':type, 'semester': 'Three'},
      token: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjExLCJpYXQiOjE3MjY1NTQ5MTgsImV4cCI6MTc1NzY1ODkxOH0.eXlnrHovOw5G-GbQb48rN0qIHsW06ly1w4Ot3favDcY'
    ).then((value)
    {
      announcementModel = AnnouncementModel.fromJson(value.data);
      emit(AdminSaveAnnouncementSuccessState(announcementModel!));
      getAnnouncements();
    }).catchError((error)
    {
      emit(AdminSaveAnnouncementsErrorState(error));
    });

  }
  List<AnnouncementModel>? announcements;
  void getAnnouncements()
  {
    emit(AdminGetAnnouncementLoadingState());
    DioHelp.getData(path: ANNOUNCEMENTS).then((value){
      announcements = [];
      value.data.forEach((element){
        announcements!.add(AnnouncementModel.fromJson(element));
      });
      emit(AdminGetAnnouncementSuccessState(announcements!));
    });
  }

}
