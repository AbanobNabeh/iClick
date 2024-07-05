import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/home/data/models/storiesmodel.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/widgets/homepagewid.dart';
import 'package:iclick/features/home/presentation/widgets/storywid.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:video_player/video_player.dart';

class MystoryScreen extends StatefulWidget {
  const MystoryScreen({super.key});

  @override
  State<MystoryScreen> createState() => _MystoryScreenState();
}

class _MystoryScreenState extends State<MystoryScreen> {
  int currentStoryIndex = 0;
  List<double> percentWatched = [];
  late List<Stories> stories;
  VideoPlayerController? videoPlayerController;
  UserModel? userModel;
  late Timer timer;
  @override
  void initState() {
    stories = HomeCubit.get(context).mystory;
    userModel = SplachscreenCubit.get(context).profile!;
    for (int i = 0; i < stories.length; i++) {
      percentWatched.add(0);
    }
    stories[currentStoryIndex].video != null ? initvideo() : _startWatching();
    super.initState();
  }

  void initvideo() {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse("${AppUrl.stories}${stories[currentStoryIndex].video}"))
      ..initialize().then((value) {
        _startWatching(
            time: videoPlayerController!.value.duration.inMilliseconds ~/ 100);
        videoPlayerController!.play();
      });
  }

  void _startWatching({int? time}) async {
    timer = Timer.periodic(Duration(milliseconds: time == null ? 50 : time),
        (timer) {
      setState(() {
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        } else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();
          if (currentStoryIndex < stories.length - 1) {
            currentStoryIndex++;
            stories[currentStoryIndex].video != null
                ? initvideo()
                : _startWatching();
          } else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _pausetime() {
    setState(() {
      timer.cancel();
      stories[currentStoryIndex].video != null
          ? videoPlayerController!.pause()
          : null;
    });
  }

  void _playtime() {
    setState(() {
      _startWatching(
          time: videoPlayerController!.value.duration.inMilliseconds ~/ 100);
      videoPlayerController!.play();
    });
  }

  @override
  void dispose() {
    videoPlayerController!.pause();
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
              onLongPressStart: (details) => _pausetime(),
              onLongPressEnd: (details) =>
                  stories[currentStoryIndex].video != null
                      ? _playtime()
                      : _startWatching(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQueryValues(context).width,
                      height: MediaQueryValues(context).height,
                      child: Stack(
                        children: [
                          Center(
                            child: stories[currentStoryIndex].video == null
                                ? Components.defchachedimg(
                                    "${AppUrl.stories}${userModel!.email}/${stories[currentStoryIndex].image}")
                                : AspectRatio(
                                    aspectRatio: videoPlayerController!
                                        .value.aspectRatio,
                                    child: VideoPlayer(videoPlayerController!),
                                  ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (currentStoryIndex == 0) {
                                      Navigator.pop(context);
                                    } else {
                                      stories[currentStoryIndex].video != null
                                          ? videoPlayerController!.dispose()
                                          : null;
                                      percentWatched[currentStoryIndex] = 0;
                                      timer.cancel();
                                      currentStoryIndex--;
                                      percentWatched[currentStoryIndex] = 0;
                                      stories[currentStoryIndex].video != null
                                          ? initvideo()
                                          : _startWatching();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (stories.length - 1 ==
                                          currentStoryIndex) {
                                        Navigator.pop(context);
                                      } else {
                                        stories[currentStoryIndex].video != null
                                            ? videoPlayerController!.dispose()
                                            : null;
                                        percentWatched[currentStoryIndex] = 1;
                                        timer.cancel();
                                        currentStoryIndex++;
                                        stories[currentStoryIndex].video != null
                                            ? initvideo()
                                            : _startWatching();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              progressbar(context, stories, percentWatched),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, top: 10, right: 10),
                                child: Row(
                                  children: [
                                    Components.defchachedimg(
                                        Stringconstants.basicimg(userModel),
                                        wid: 45,
                                        high: 45,
                                        circular: true),
                                    Components.sizedwd(size: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Components.defText(
                                            text: "Your Story", size: 18),
                                        Components.defText(
                                            text: TimeFormate.formatTimeAgo(
                                                DateTime.parse(
                                                    stories[currentStoryIndex]
                                                        .date!)),
                                            size: 14),
                                      ],
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Icon(
                                        IconBroken.Close_Square,
                                        color: AppColors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              HomeCubit.get(context).getviewrsstory(
                                  stories[currentStoryIndex].id!);
                              _pausetime();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => viewersstory(
                                    HomeCubit.get(context).viewrs, context),
                              ).whenComplete(() {
                                HomeCubit.get(context).viewrs = [];
                                stories[currentStoryIndex].video != null
                                    ? _playtime()
                                    : _startWatching();
                              });
                            },
                            onVerticalDragUpdate: (details) {
                              HomeCubit.get(context).getviewrsstory(
                                  stories[currentStoryIndex].id!);
                              _pausetime();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => viewersstory(
                                    HomeCubit.get(context).viewrs, context),
                              ).whenComplete(() {
                                HomeCubit.get(context).viewrs = [];
                                stories[currentStoryIndex].video != null
                                    ? _playtime()
                                    : _startWatching();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      MyFlutterApp.eye,
                                      color: AppColors.primary,
                                    ),
                                    Components.defText(
                                        text:
                                            " ${stories[currentStoryIndex].view!}"),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox();
                  },
                  itemCount: stories.length))),
    );
  }
}
