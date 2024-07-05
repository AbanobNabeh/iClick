import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(FollowInitial());
  static FollowCubit get(context) => BlocProvider.of(context);
  List<UserModel> followers = [];
  void follow(UserModel user, BuildContext context) {
    UserModel myprofile = SplachscreenCubit.get(context).profile!;
    DioApp.postData(url: AppUrl.follow, data: {"iduser": user.id!})
        .then((value) {
      APInotification.sendnotifiuser(
          to: user.fcmtoken!,
          title: "${myprofile.firstname} ${myprofile.lastname}",
          body: "Started Following You",
          type: "user",
          link: myprofile.id.toString());
      APInotification.subscribeToTopic("USER${user.id.toString()}");
    });
  }

  void getfollowers(String iduser, bool isfollowers) {
    if (isfollowers) {
      emit(GetFollowersLoading());
      followers = [];
      DioApp.getData(url: "${AppUrl.getfollowers}/$iduser").then((value) {
        value.data['date'].forEach((element) {
          print(element['userfrom']);
          followers.add(UserModel.fromJson(element['userfrom']));
        });
        emit(GetFollowersSuccess());
      });
    } else {
      getfollowing(iduser);
    }
  }

  void getfollowing(String iduser) {
    emit(GetFollowersLoading());
    followers = [];
    DioApp.getData(url: "${AppUrl.getfollowing}/$iduser").then((value) {
      value.data['date'].forEach((element) {
        followers.add(UserModel.fromJson(element['userto']));
      });
      emit(GetFollowersSuccess());
    });
  }
}
