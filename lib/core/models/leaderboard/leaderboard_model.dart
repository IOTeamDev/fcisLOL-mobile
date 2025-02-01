class LeaderboardModel {
  int? id;
  int? score;
  String? name;
  int? userRank;
  String? photo;


  LeaderboardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    score = json['score'] ?? 0;
    name = json['name'] ?? '';
    photo = json['photo']??'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/140.jpg?alt=media&token=3e5a4144-20ca-44ce-ba14-57432e49914f';
  }
}
