class FcmToken {
  late String semester;

  late String fcmToken;

  FcmToken.fromJson(Map<String, dynamic> model) {
    semester = model["semester"] ;
    fcmToken = model["fcmToken"];
  }
}
