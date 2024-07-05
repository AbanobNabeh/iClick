import 'package:iclick/features/auth/data/models/usermodel.dart';

class ViewStoryModel {
  int? id;
  String? iduser;
  String? idstory;
  String? like;
  UserModel? getuser;

  ViewStoryModel({this.id, this.iduser, this.idstory, this.getuser});

  ViewStoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    idstory = json['idstory'];
    like = json['like'];
    getuser = json['getuser'] != null
        ? new UserModel.fromJson(json['getuser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['idstory'] = this.idstory;
    data['like'] = this.like;
    if (this.getuser != null) {
      data['getuser'] = this.getuser!.toJson();
    }
    return data;
  }
}
