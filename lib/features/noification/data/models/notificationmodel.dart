import 'package:iclick/features/auth/data/models/usermodel.dart';

class NotificationModel {
  int? id;
  String? fromuser;
  String? touser;
  String? type;
  String? link;
  String? seen;
  String? date;
  UserModel? user;

  NotificationModel(
      {this.id,
      this.fromuser,
      this.touser,
      this.type,
      this.link,
      this.seen,
      this.date,
      this.user});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromuser = json['fromuser'];
    touser = json['touser'];
    type = json['type'];
    link = json['link'];
    seen = json['seen'];
    date = json['date'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromuser'] = this.fromuser;
    data['touser'] = this.touser;
    data['type'] = this.type;
    data['link'] = this.link;
    data['seen'] = this.seen;
    data['date'] = this.date;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
