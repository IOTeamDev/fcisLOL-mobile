class CurrentUserModel
{
  int? id;
  String? email;
  String? name;
  String? semester;
  String? role;
  dynamic photo;
  dynamic phone;

  CurrentUserModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id']??0;
    email = json['email']??'';
    name = json['name']??'';
    semester = json['semester']??'';
    role = json['role']??'STUDENT';
    photo = json['photo']??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s';
    phone = json['phone']??'';
  }

}