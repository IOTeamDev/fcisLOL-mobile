class FcmToken {
  late String semester;
  String?  fcmToken;
  late String  name;

  FcmToken.fromJson(Map<String, dynamic> model) {
    semester = model["semester"] ;
    fcmToken = model["fcmToken"];
    name = model["name"];
  }
}
