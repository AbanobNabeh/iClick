import 'package:iclick/features/auth/data/models/usermodel.dart';

class PostModel {
  int? id;
  String? iduser;
  String? image;
  String? likes;
  String? date;
  String? relationship;
  bool? liked;
  UserModel? user;

  PostModel(
      {this.id,
      this.iduser,
      this.image,
      this.likes,
      this.date,
      this.relationship,
      this.liked,
      this.user});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    image = json['image'];
    likes = json['likes'];
    date = json['date'];
    relationship = json['relationship'];
    liked = json['liked'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['image'] = this.image;
    data['likes'] = this.likes;
    data['date'] = this.date;
    data['relationship'] = this.relationship;
    data['liked'] = this.liked;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
