class UsersModel {
  late String name;
  late String email;
  late String semester;
  late String role;
  String? phone;
  late String photo;
UsersModel.fromJson(Map model){

  name = model['name'];
  email = model['email'];
  semester = model['semester'];
  role = model['role'];
  phone = model['phone']??"";
  photo = model['photo']??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s';
}


}
