class AuthorModel {
  String? authorName;
  String? authorPhoto;

  AuthorModel({required this.authorName, required this.authorPhoto});

  AuthorModel.fromJson(Map<String, dynamic> json) {
    authorName = json['name'];
    authorPhoto = json['photo'] ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s';
  }
}
