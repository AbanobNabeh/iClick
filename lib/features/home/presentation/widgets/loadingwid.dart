import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

Widget lodaingPost() {
  return ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.secblack,
              highlightColor: AppColors.grey.withOpacity(0.5),
              child: Container(
                height: 355,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.secblack),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.secblack,
                  highlightColor: AppColors.grey.withOpacity(0.5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.blue,
                      ),
                      Components.sizedwd(size: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 15,
                            decoration: BoxDecoration(
                                color: AppColors.secblack,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          Components.sizedhg(size: 5),
                          Container(
                            width: 80,
                            height: 15,
                            decoration: BoxDecoration(
                                color: AppColors.secblack,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Components.sizedhg(size: 15),
                Center(
                  child: Shimmer.fromColors(
                    baseColor: AppColors.secblack,
                    highlightColor: AppColors.grey.withOpacity(0.5),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          color: AppColors.secblack,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) {
      return Components.sizedwd(size: 10);
    },
    itemCount: 10,
  );
}

Widget loadingStories() {
  return Container(
    height: 120,
    child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.secblack,
            highlightColor: AppColors.grey.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 44,
                ),
                Components.sizedhg(size: 10),
                Container(
                  width: 80,
                  height: 15,
                  decoration: BoxDecoration(
                      color: AppColors.secblack,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Components.sizedwd(size: 10);
        },
        itemCount: 10),
  );
}
