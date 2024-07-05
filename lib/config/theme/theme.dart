import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iclick/core/utils/asset_manger.dart';

import '../../core/utils/app_colors.dart';

class AppTheme {
  static ThemeData lighttheme() {
    return ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: AppColors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            actionsIconTheme: IconThemeData(color: AppColors.white),
            backgroundColor: AppColors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.black),
            titleTextStyle: TextStyle(
              color: AppColors.black,
              fontFamily: "Marhey-Medium",
              fontSize: 25,
            )),
        fontFamily: 'Marhey-Medium',
        backgroundColor: AppColors.white,
        scaffoldBackgroundColor: AppColors.white);
  }

  static Widget background() {
    return Stack(
      children: [
        Image.asset(
          IMGManger.bg,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: HexColor('#5252C7').withOpacity(0.20),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: HexColor('#0F0F0F').withOpacity(0.30),
        ),
      ],
    );
  }

  static ThemeData darktheme() {
    return ThemeData(
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.black),
      dialogBackgroundColor: HexColor('404040'),
      scaffoldBackgroundColor: HexColor('404040'),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: HexColor('404040'),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        actionsIconTheme: IconThemeData(color: AppColors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: HexColor('404040'),
        ),
      ),
      primaryColor: HexColor('F4A135'),
    );
  }
}
