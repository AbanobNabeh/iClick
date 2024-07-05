import 'package:iclick/features/auth/data/models/usermodel.dart';

class CommentModel {
  int? id;
  String? iduser;
  String? comment;
  String? link;
  String? type;
  String? like;
  String? date;
  bool? liked;
  int? replies;
  UserModel? userinfo;

  CommentModel(
      {this.id,
      this.iduser,
      this.comment,
      this.link,
      this.type,
      this.like,
      this.date,
      this.liked,
      this.replies,
      this.userinfo});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    comment = json['comment'];
    link = json['link'];
    type = json['type'];
    like = json['like'];
    date = json['date'];
    liked = json['liked'];
    replies = json['replies'];
    userinfo = json['userinfo'] != null
        ? new UserModel.fromJson(json['userinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['comment'] = this.comment;
    data['link'] = this.link;
    data['type'] = this.type;
    data['like'] = this.like;
    data['date'] = this.date;
    data['liked'] = this.liked;
    data['replies'] = this.replies;
    if (this.userinfo != null) {
      data['userinfo'] = this.userinfo!.toJson();
    }
    return data;
  }
}
