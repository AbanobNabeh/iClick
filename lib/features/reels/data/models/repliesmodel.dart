import 'package:iclick/features/auth/data/models/usermodel.dart';

class RepliesModel {
  int? id;
  String? iduser;
  String? repaly;
  String? idcomment;
  String? like;
  String? date;
  bool? liked;
  UserModel? userinfo;

  RepliesModel(
      {this.id,
      this.iduser,
      this.repaly,
      this.idcomment,
      this.like,
      this.date,
      this.liked,
      this.userinfo});

  RepliesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    repaly = json['repaly'];
    idcomment = json['idcomment'];
    like = json['like'];
    date = json['date'];
    liked = json['liked'];
    userinfo = json['userinfo'] != null
        ? new UserModel.fromJson(json['userinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['repaly'] = this.repaly;
    data['idcomment'] = this.idcomment;
    data['like'] = this.like;
    data['date'] = this.date;
    data['liked'] = this.liked;
    if (this.userinfo != null) {
      data['userinfo'] = this.userinfo!.toJson();
    }
    return data;
  }
}
