import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:lol/modules/admin/bloc/admin_cubit_states.dart';
import 'package:lol/models/admin/announcement_model.dart';
import 'package:lol/models/admin/requests_model.dart';
import 'package:lol/modules/admin/screens/announcements/add_announcement.dart';
//import 'package:lol/modules/auth/bloc/login_cubit_states.dart';
import 'package:lol/models/login/login_model.dart';
import 'package:lol/shared/components/components.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);

  AnnouncementModel? announcementModel;
  void addAnnouncement(
      {required title, description, required dueDate, required type}) {
    emit(AdminSaveAnnouncementLoadingState());
    DioHelp.postData(
            path: ANNOUNCEMENTS,
            data: {
              'title': title,
              'content': description ?? '',
              'due_date': dueDate,
              'type': type,
              'semester': 'Three'
            },
            token:
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcyNzAxMjQzOSwiZXhwIjoxNzU4MTE2NDM5fQ.WdqfOR7HKHMUYKax1w5P0awJZyuLBZqDl5ia602b4Wk')
        .then((value) {
      //announcementModel = AnnouncementModel.fromJson(value.data);
      emit(AdminSaveAnnouncementSuccessState());
      getAnnouncements();
    }).catchError((error) {
      emit(AdminSaveAnnouncementsErrorState(error));
    });
  }

  List<AnnouncementModel>? announcements;
  void getAnnouncements() {
    emit(AdminGetAnnouncementLoadingState());
    DioHelp.getData(path: ANNOUNCEMENTS).then((value) {
      announcements = [];
      value.data.forEach((element) {
        announcements!.add(AnnouncementModel.fromJson(element));
      });
      emit(AdminGetAnnouncementSuccessState(announcements!));
    });
  }

  void updateAnnouncement(final String id,
      {String? title, String? content, dynamic dueDate, String? type}) {
    emit(AdminUpdateAnnouncementLoadingState());
    DioHelp.putData(
        path: ANNOUNCEMENTS,
        data: {
          'title': title,
          'content': content,
          'due_date': dueDate,
          'type': type,
          'semester': 'Four'
        },
        token:
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcyNzAxMjQzOSwiZXhwIjoxNzU4MTE2NDM5fQ.WdqfOR7HKHMUYKax1w5P0awJZyuLBZqDl5ia602b4Wk',
        query: {'id': int.parse(id)}).then((value) {
      print(value.data);
      // Assuming the response returns the updated announcement
      AnnouncementModel updatedAnnouncement =
          AnnouncementModel.fromJson(value.data);

      // Update the local announcements list
      if (announcements != null) {
        int index = announcements!.indexWhere((ann) => ann.id.toString() == id);
        if (index != -1) {
          announcements![index] = updatedAnnouncement;
        }
      }
      emit(AdminUpdateAnnouncementSuccessState());
    }).catchError((error) {
      emit(AdminUpdateAnnouncementErrorState(error.toString()));
    });
  }

  void deleteAnnouncement(int id) {
    emit(AdminDeleteAnnouncementLoadingState());
    DioHelp.deleteData(
        path: ANNOUNCEMENTS,
        token:
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcyNzAxMjQzOSwiZXhwIjoxNzU4MTE2NDM5fQ.WdqfOR7HKHMUYKax1w5P0awJZyuLBZqDl5ia602b4Wk',
        query: {'id': id}).then((value) {
      emit(AdminDeleteAnnouncementSuccessState());
      getAnnouncements();
    });
  }

  List<RequestsModel>? requests;
  void getRequests() {
    emit(AdminGetRequestsLoadingState());
    DioHelp.getData(
        path: MATERIAL,
        query: {'subject': 'CALC_1', 'accepted': false}).then((value) {
      requests = [];
      value.data.forEach((element) {
        requests!.add(RequestsModel.fromJson(element));
        print(value.data);
        print(requests![0].id);
      });

      emit(AdminGetRequestsSuccessState(requests!));
    });
  }

  void deleteMaterial(int id) {
    emit(AdminDeleteMaterialLoadingState());
    DioHelp.deleteData(
            path: MATERIAL,
            data: {'id': id},
            token:
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcyNzAxMjQzOSwiZXhwIjoxNzU4MTE2NDM5fQ.WdqfOR7HKHMUYKax1w5P0awJZyuLBZqDl5ia602b4Wk')
        .then((value) {
      emit(AdminDeleteMaterialSuccessState());
      getRequests();
    });
  }

  void acceptRequest(int id) {
    emit(AdminAcceptRequestLoadingState());
    DioHelp.getData(
            path: ACCEPT,
            query: {'id': id, 'accepted': true},
            token:
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTcyNzAxMjQzOSwiZXhwIjoxNzU4MTE2NDM5fQ.WdqfOR7HKHMUYKax1w5P0awJZyuLBZqDl5ia602b4Wk')
        .then((value) {
      emit(AdminAcceptRequestSuccessState());
      getRequests();
    });
  }
}
