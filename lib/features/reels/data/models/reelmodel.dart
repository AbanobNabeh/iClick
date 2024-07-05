import 'package:iclick/features/auth/data/models/usermodel.dart';

class ReelModel {
  int? id;
  String? iduser;
  String? video;
  String? caption;
  String? like;
  String? comment;
  String? share;
  String? createdAt;
  String? updatedAt;
  String? relationship;
  bool? liked;
  UserModel? user;

  ReelModel(
      {this.id,
      this.iduser,
      this.video,
      this.caption,
      this.like,
      this.comment,
      this.createdAt,
      this.share,
      this.updatedAt,
      this.relationship,
      this.liked,
      this.user});

  ReelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    video = json['video'];
    caption = json['caption'];
    like = json['like'];
    comment = json['comment'];
    share = json['share'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    relationship = json['relationship'];
    liked = json['liked'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['video'] = this.video;
    data['caption'] = this.caption;
    data['like'] = this.like;
    data['comment'] = this.comment;
    data['share'] = this.share;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['relationship'] = this.relationship;
    data['liked'] = this.liked;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
