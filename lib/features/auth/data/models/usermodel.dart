import 'package:iclick/features/home/data/models/storiesmodel.dart';

class UserModel {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? image;
  String? bio;
  String? category;
  String? followers;
  String? following;
  String? website;
  String? instagram;
  String? facebook;
  String? token;
  String? createdAt;
  String? updatedAt;
  String? fcmtoken;
  bool? watch;
  List<Stories>? stories;
  String? relationship;
  int? countposts;

  UserModel(
      {this.id,
      this.firstname,
      this.lastname,
      this.username,
      this.email,
      this.image,
      this.bio,
      this.category,
      this.followers,
      this.following,
      this.website,
      this.instagram,
      this.facebook,
      this.token,
      this.createdAt,
      this.updatedAt,
      this.fcmtoken,
      this.relationship,
      this.countposts,
      this.watch,
      this.stories});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    email = json['email'];
    image = json['image'];
    bio = json['bio'];
    category = json['category'];
    followers = json['followers'];
    following = json['following'];
    website = json['website'];
    fcmtoken = json['FCMtoken'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    relationship = json['relationship'];
    countposts = json['countposts'];
    watch = json['watch'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['category'] = this.category;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['website'] = this.website;
    data['instagram'] = this.instagram;
    data['facebook'] = this.facebook;
    data['FCMtoken'] = this.fcmtoken;
    data['token'] = this.token;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['relationship'] = this.relationship;
    data['countposts'] = this.countposts;
    data['watch'] = this.watch;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
