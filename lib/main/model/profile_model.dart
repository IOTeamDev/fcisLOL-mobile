class ProfileModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  String? phone;
  late String photo;
ProfileModel.fromJson(Map model){

  name = model['name'];
  email = model['email'];
  semester = model['semester'];
  role = model['role'];
  phone = model['phone']??"";
  photo = model['photo'];
}


}
