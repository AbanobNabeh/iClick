import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/addpost/presentation/pages/editphoto.dart';
import 'package:iclick/features/addpost/presentation/pages/video.dart';
import 'package:photo_manager/photo_manager.dart';

Widget galleryWid(
    {required AddpostCubit cubit, required BuildContext context}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 375,
          child: GridView.builder(
            itemCount: cubit.images.isEmpty ? cubit.images.length : 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              return cubit.images[cubit.indexx];
            },
          ),
        ),
        Container(
          width: double.infinity,
          height: 40,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Components.defText(
                  text: 'Recent', size: 15, fontWeight: FontWeight.w600),
            ],
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cubit.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => cubit.changeimage(index),
              child: cubit.images[index],
            );
          },
        ),
      ],
    ),
  );
}

Widget itemgallery(AssetEntity image) {
  return FutureBuilder(
    future: image.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
    builder: (context, snapshot) {
      return Stack(
        children: [
          snapshot.connectionState == ConnectionState.done
              ? Positioned.fill(
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Components.loadingwidget(),
                )
        ],
      );
    },
  );
}

Widget reelWid({required AddpostCubit cubit, required BuildContext context}) {
  return GridView.builder(
    shrinkWrap: true,
    itemCount: cubit.videos.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisExtent: 250,
      crossAxisSpacing: 3,
      mainAxisSpacing: 5,
    ),
    itemBuilder: (context, index) {
      return GestureDetector(
          onTap: () {
            if (cubit.videos[index].videoDuration.inSeconds > 30 ||
                cubit.videos[index].videoDuration.inMinutes >= 1) {
              Components.errormessage(
                  context: context,
                  message: "You cannot choose a video of more than 30 seconds");
            } else {
              cubit.videos[index].file.then((value) {
                cubit.videofile = File(value!.path);
                AppRoutes.animroutepush(
                    context: context,
                    screen: UploadReelScreen(cubit.videofile!));
              });
            }
          },
          child: FutureBuilder(
            future: cubit.videos[index]
                .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (cubit.videos[index].type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.secblack.withOpacity(0.5)),
                          child: Row(
                            children: [
                              Text(
                                cubit.videos[index].videoDuration.inMinutes
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                ':',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                cubit.videos[index].videoDuration.inSeconds
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                );
              }

              return Container();
            },
          ));
    },
  );
}

Widget media({required AddpostCubit cubit, required BuildContext context}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cubit.media.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: cubit.media[index].type == AssetType.video
                  ? () {
                      if (cubit.media[index].videoDuration.inSeconds > 30 ||
                          cubit.media[index].videoDuration.inMinutes >= 1) {
                        Components.errormessage(
                            context: context,
                            message:
                                "You cannot choose a video of more than 30 seconds");
                      } else {
                        cubit.media[index].file.then((value) {
                          cubit.videofile = File(value!.path);
                          AppRoutes.animroutepush(
                              context: context,
                              screen: UploadReelScreen(cubit.videofile!));
                        });
                      }
                    }
                  : () {
                      cubit.media[index].file.then((value) async {
                        cubit.filee = File(value!.path);

                        AppRoutes.animroutepush(
                            context: context, screen: EditPhoto());
                      });
                    },
              child: FutureBuilder(
                future: cubit.media[index]
                    .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      snapshot.connectionState == ConnectionState.done
                          ? Positioned.fill(
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Components.loadingwidget(),
                            ),
                      (cubit.media[index].type == AssetType.video)
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Text(
                                        cubit.media[index].videoDuration
                                            .inMinutes
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        cubit.media[index].videoDuration
                                            .inSeconds
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}
