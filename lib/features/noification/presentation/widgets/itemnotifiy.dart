import 'package:flutter/material.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';

Widget iconbytype(String type) {
  if (type == "follow") {
    return Icon(
      MyFlutterApp.user_plus,
      size: 18,
      color: AppColors.primary,
    );
  } else {
    if (Stringconstants.typenotifiy(type, false) == "Comment" ||
        Stringconstants.typenotifiy(type, false) == "Replay") {
      return const Icon(
        MyFlutterApp.comment,
        size: 18,
        color: Colors.green,
      );
    } else {
      return const Icon(
        MyFlutterApp.heart,
        size: 18,
        color: Colors.red,
      );
    }
  }
}
