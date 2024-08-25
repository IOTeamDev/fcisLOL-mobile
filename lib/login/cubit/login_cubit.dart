import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/login/cubit/login_cubit_states.dart';

//uid null?
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(Initial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool hiddenPassword = true;

  togglePassword() {
    hiddenPassword = !hiddenPassword;

    emit(togglePassword());
  }

  void login({required email, required password}) async {
    emit(Loading());
  }

  void getData() {
    emit(Loading());
  }

  // void UpdateData({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String uiD,
  //   required bool isEmailVerified,
  //   required String backgroundImagePath,
  //   required String profileImagePath,

  // }) {
  //   FirebaseFirestore.instance.collection("Users").doc(uID).update();
  // }
}
