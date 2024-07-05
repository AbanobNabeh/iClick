import 'package:flutter/material.dart';
import 'package:iclick/core/utils/asset_manger.dart';

Widget bgwelcome({required Widget widget}) {
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Column(
        children: [
          Image.asset(
            IMGManger.welcome,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ],
      ),
      widget
    ],
  );
}
