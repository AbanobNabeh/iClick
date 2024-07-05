import 'package:iclick/features/auth/data/models/usermodel.dart';

class FollowersModel {
  String? id;
  String? fromuser;
  UserModel? userto;

  FollowersModel({this.id, this.fromuser, this.userto});

  FollowersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromuser = json['fromuser'];
    userto =
        json['userto'] != null ? new UserModel.fromJson(json['userto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromuser'] = this.fromuser;
    if (this.userto != null) {
      data['userto'] = this.userto!.toJson();
    }
    return data;
  }
}
