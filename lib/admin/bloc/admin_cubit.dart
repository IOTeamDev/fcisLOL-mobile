import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/admin/screens/add_anouncment.dart';
import 'package:lol/auth/bloc/login_cubit_states.dart';
import 'package:lol/auth/model/login_model.dart';
import 'package:lol/utilities/dio.dart';

//uid null?
class AdminCubit extends Cubit<AdminCubitStates> {
  AdminCubit() : super(InitialAdminState());

  static AdminCubit get(context) => BlocProvider.of(context);

}
