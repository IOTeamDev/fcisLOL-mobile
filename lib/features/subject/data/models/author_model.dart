class AuthorModel {
  String? authorName;
  String? authorPhoto;

  AuthorModel({required this.authorName, required this.authorPhoto});

  AuthorModel.fromJson(Map<String, dynamic> json) {
    authorName = json['name'];
    authorPhoto = json['photo'];
  }
}
