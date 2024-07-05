import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/app.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/config/shared%20preferences/shared_preferences.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/auth/presentation/pages/signin.dart';
import 'package:iclick/features/home/data/models/postmodel.dart';
import 'package:iclick/features/reels/data/models/reelmodel.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  int indexpage = 0;
  late UserModel profileUser;
  final controllerscroll = ScrollController();
  List<PostModel> posts = [];
  List<ReelModel> reels = [];
  int postspage = 1;
  int reelspage = 1;
  TextEditingController firstnamecon = TextEditingController();
  TextEditingController lastnamecon = TextEditingController();
  TextEditingController usernamecon = TextEditingController();
  TextEditingController facebookcon = TextEditingController();
  TextEditingController instagramcon = TextEditingController();
  TextEditingController biocon = TextEditingController();
  TextEditingController currentpasscon = TextEditingController();
  TextEditingController newpasscon = TextEditingController();
  TextEditingController confrimpasscon = TextEditingController();
  TextEditingController otpcon = TextEditingController();
  bool usernameused = false;
  bool isOTP = false;
  IconData visipw = IconBroken.Hide;
  bool obscureText = true;
  bool passerror = false;
  int start = 60;
  bool timer = false;
  void shareprofile(int id) async {
    Share.share("${AppUrl.sharelink}?profile=$id");
  }

  void getProfileUser(iduser) {
    emit(GetProfileUserLoading());
    DioApp.getData(url: "${AppUrl.getUserinfo}/$iduser").then((value) {
      profileUser = UserModel.fromJson(value.data['date']);
      emit(GetProfileUserSuccess());
      getPostsUser(iduser);
    });
  }

  void launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void getPostsUser(iduser) {
    postspage == 1 ? posts = [] : null;
    postspage == 1 ? emit(GetPostsUserLoading()) : null;
    DioApp.getData(
        url: "${AppUrl.getPostsuser}/$iduser",
        query: {'page': postspage}).then((value) {
      value.data['date'].forEach((element) {
        posts.add(PostModel.fromJson(element));
      });
      emit(GetPostsUserSuccess());
    });
  }

  void changeIndex(value, iduser) {
    indexpage = value;
    emit(ChangeIndexState());
    if (value == 0) {
      postspage = 1;
      getPostsUser(iduser);
    } else {
      reelspage = 1;
      getReelsUser(iduser);
    }
  }

  void followuser(BuildContext context) {
    UserModel myprofile = SplachscreenCubit.get(context).profile!;

    emit(FollowUserLoading());
    DioApp.postData(url: AppUrl.follow, data: {'iduser': profileUser.id})
        .then((value) {
      int follow = int.parse(profileUser.followers!) + 1;
      profileUser.relationship = value.data['message'];
      profileUser.followers = follow.toString();
      APInotification.sendnotifiuser(
          to: profileUser.fcmtoken!,
          title: "${myprofile.firstname} ${myprofile.lastname}",
          body: "Started Following You",
          type: "user",
          link: myprofile.id.toString());
      APInotification.subscribeToTopic("USER${profileUser.id.toString()}");

      emit(FollowUserSuccess());
    });
  }

  void unfollowuser() {
    emit(FollowUserLoading());
    DioApp.postData(url: AppUrl.unfollow, data: {'iduser': profileUser.id})
        .then((value) {
      int follow = int.parse(profileUser.followers!) - 1;
      profileUser.relationship = value.data['message'];
      profileUser.followers = follow.toString();
      APInotification.unsubscribeToTopic("USER${profileUser.id.toString()}");

      emit(FollowUserSuccess());
    });
  }

  void getReelsUser(iduser) {
    reelspage == 1 ? reels = [] : null;
    reelspage == 1 ? emit(GetReelsUserLoading()) : null;
    DioApp.getData(
        url: "${AppUrl.getReelsuser}/$iduser",
        query: {'page': reelspage}).then((value) {
      value.data['date'].forEach((element) {
        reels.add(ReelModel.fromJson(element));
      });
      emit(GetReelsUserSuccess());
    });
  }

  void logout(BuildContext context) {
    DioApp.getData(url: AppUrl.logout).then((value) {
      CacheHelper.removeData(key: Stringconstants.isuser).then((_) {
        AppRoutes.animrouteremove(context: context, screen: SigninScreen());
      });
    });
  }

  void initEditprofile(UserModel profile) {
    firstnamecon.text = profile.firstname!;
    lastnamecon.text = profile.lastname!;
    usernamecon.text = profile.username!;
    instagramcon.text = profile.instagram ?? "";
    facebookcon.text = profile.facebook ?? "";
    biocon.text = profile.bio ?? "";
  }

  File? image;
  final ImagePicker pickerimage = ImagePicker();
  Future<void> selectImage({required BuildContext context, phonenumber}) async {
    final photo = await pickerimage.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      image = File(photo.path);
      emit(ImageSuccess());
    } else {
      emit(ImageError());
    }
  }

  void refrashstate() {
    emit(RefrashState());
  }

  void editprofile(BuildContext context) {
    usernameused = false;
    emit(EditProfileLoading());
    DioApp.postData(url: AppUrl.updateprofile, data: {
      'firstname': firstnamecon.text,
      'lastname': lastnamecon.text,
      'username': usernamecon.text,
      'bio': biocon.text,
      'insta': instagramcon.text,
      'face': facebookcon.text,
    }).then((value) {
      if (value.data['message'] == 'Username Already used') {
        usernameused = true;
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Components.successmessage(
            context: context, message: "Updated successfully");
      }
      emit(EditProfileSuccess());
    });
  }

  void updateimage(BuildContext context) async {
    emit(EditProfileLoading());
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image!.path),
      'firstname': firstnamecon.text,
      'lastname': lastnamecon.text,
      'username': usernamecon.text,
      'bio': biocon.text,
      'insta': instagramcon.text,
      'face': facebookcon.text,
    });
    DioApp.postimg(url: AppUrl.updateimage, data: formData).then((value) {
      if (value.data['message'] == 'Username Already used') {
        usernameused = true;
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Components.successmessage(
            context: context, message: "Updated successfully");
      }
      emit(EditProfileSuccess());
    });
  }

  void switchtootp() {
    isOTP = !isOTP;
    emit(ChangeOTPState());
  }

  void changeobscure() {
    obscureText ? visipw = IconBroken.Show : visipw = IconBroken.Hide;
    obscureText = !obscureText;
    emit(ChangeObscureState());
  }

  void resetpw(BuildContext context) {
    emit(ResetPasswordLoading());
    passerror = false;
    DioApp.postData(url: AppUrl.resetpassword, data: {
      'type': "pass",
      "currentpass": currentpasscon.text,
      "password": newpasscon.text
    }).then((value) {
      if (value.data['status'] == 'correct') {
        passerror = true;
      } else {
        Navigator.pop(context);
        Components.successmessage(
            context: context, message: "Changed successfully");
      }
      emit(ResetPasswordSuccess());
    });
  }

  void sendotp() {
    emit(SendOTPLoading());
    DioApp.getData(url: AppUrl.sendotp).then((value) {
      Timer.periodic(const Duration(seconds: 1), (timeer) {
        if (start == 0) {
          start = 60;
          timer = false;
          timeer.cancel();
        } else {
          timer = true;
          start--;
        }
        emit(StartTimerOTP());
      });
    });
  }

  void resetpwbyotp(BuildContext context) {
    emit(ResetPasswordLoading());
    passerror = false;
    DioApp.postData(url: AppUrl.resetpassword, data: {
      'type': "code",
      "otp": otpcon.text,
      "password": newpasscon.text
    }).then((value) {
      print(value.data);
      if (value.data['status'] == 'codeisinvalid') {
        passerror = true;
      } else {
        Navigator.pop(context);
        Components.successmessage(
            context: context, message: "Changed successfully");
      }
      emit(ResetPasswordSuccess());
    });
  }

  void deleteaccount(BuildContext context) {
    DioApp.getData(url: AppUrl.removeuser).then((value) {
      CacheHelper.removeData(key: Stringconstants.isuser).then((_) {
        Restart.restartApp();
      });
    });
  }
}
