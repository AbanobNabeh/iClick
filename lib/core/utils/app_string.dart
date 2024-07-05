import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/shared%20preferences/shared_preferences.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';

class Stringconstants {
  static var isuser = 'token';
  static var token = CacheHelper.getData(key: isuser);

  static String basicimg(UserModel? info) {
    if (info!.image == null) {
      return AppUrl.basicimg;
    } else {
      return "${AppUrl.profileimg}${info.email}/${info.image}";
    }
  }

  static String formatNumber(String value) {
    int number = int.parse(value);
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}m';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  static String typenotifiy(String type, bool afterDash) {
    List<String> parts = type.split("-");
    if (afterDash) {
      String afterDash = parts[1];
      if (afterDash == 'post') {
        return "Photo";
      } else if (afterDash == 'story') {
        return "Story";
      } else {
        return 'Reel';
      }
    } else {
      String beforeDash = parts[0];
      if (beforeDash == 'like') {
        return "Liked Your";
      } else if (beforeDash == 'replay') {
        return "Replay";
      } else {
        return "Comment";
      }
    }
  }

  static String formatpdfname(String type) {
    List<String> parts = type.split("/");
    String afterDash = parts[1];
    return afterDash;
  }
}
