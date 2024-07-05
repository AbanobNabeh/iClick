import 'package:flutter/material.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget progressbar(
    BuildContext context, List stories, List<double> percentWatched) {
  double size = MediaQuery.of(context).size.width - 10;

  return Padding(
    padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
    child: Row(
      children: stories.asMap().entries.map((item) {
        return LinearPercentIndicator(
          padding: EdgeInsets.only(left: 3),
          barRadius: Radius.circular(15),
          width: size / stories.length,
          lineHeight: 10,
          percent: percentWatched[item.key],
          progressColor: AppColors.primary,
        );
      }).toList(),
    ),
  );
}
