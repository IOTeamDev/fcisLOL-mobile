import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/shared/components/constants.dart';
import 'package:lol/shared/network/endpoints.dart';
import 'package:lol/shared/network/remote/dio.dart';
import 'package:meta/meta.dart';

part 'delete_material_state.dart';

class DeleteMaterialCubit extends Cubit<DeleteMaterialState> {
  DeleteMaterialCubit() : super(DeleteMaterialInitial());
  static DeleteMaterialCubit get(context) => BlocProvider.of(context);

  void deleteMaterial({required String subjectName, required int id}) {
    emit(DeleteMaterialLoading());
    DioHelp.deleteData(path: MATERIAL, token: TOKEN, data: {'id': id})
        .then((response) {
      emit(DeleteMaterialSuccess());
    }).catchError((error) {
      emit(DeleteMaterialError(error: error.toString()));
      log('error from deleting material $error');
    });
  }
}
