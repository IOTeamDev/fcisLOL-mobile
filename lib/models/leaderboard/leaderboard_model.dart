class LeaderboardModel
{
  int? id;
  int? score;
  String? name;

  LeaderboardModel.fromJson(Map<String, dynamic> json)
  {
    id = json['id']??0;
    score = json['score']??0;
    name = json['name']??'';
  }
}