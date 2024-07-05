import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/like.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/home/data/models/storiesmodel.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/widgets/storywid.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class StoryScreen extends StatefulWidget {
  int initpage;
  StoryScreen(this.initpage);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentStoryIndex = 0;
  List<double> percentWatched = [];
  late PageController pageController;
  late List<UserModel> userinfo;
  late List<Stories> stories;
  bool isAnimating = false;
  VideoPlayerController? videoPlayerController;
  bool autoback = true;
  late Timer timer;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initpage);
    userinfo = HomeCubit.get(context).stories;
    stories = HomeCubit.get(context).stories[widget.initpage].stories!;
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
    HomeCubit.get(context).watchstory(stories[currentStoryIndex].id!);
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
            if (userinfo.length - 1 != widget.initpage) {
              autoback = true;
              pageController
                  .nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              )
                  .then((value) {
                autoback = false;
              });
            } else {
              autoback ? null : Navigator.pop(context);
            }
          }
        }
      });
    });
  }

  void _restartWidget() {
    setState(() {
      currentStoryIndex = 0;
      stories[currentStoryIndex].video != null
          ? videoPlayerController!.dispose()
          : null;
      percentWatched.clear();
      for (int i = 0; i < stories.length; i++) {
        percentWatched.add(0);
      }
    });
    stories[currentStoryIndex].video != null ? initvideo() : _startWatching();
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
    stories[currentStoryIndex].video != null
        ? setState(() {
            _startWatching(
                time: videoPlayerController!.value.duration.inMilliseconds ~/
                    100);
            videoPlayerController!.play();
          })
        : _startWatching();
  }

  @override
  void dispose() {
    percentWatched.clear();
    timer.cancel();
    stories[currentStoryIndex].video != null
        ? videoPlayerController!.dispose()
        : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onLongPressStart: (details) => _pausetime(),
        onLongPressEnd: (details) => stories[currentStoryIndex].video != null
            ? _playtime()
            : _startWatching(),
        child: PageView.builder(
          controller: pageController,
          allowImplicitScrolling: false,
          onPageChanged: (index) {
            timer.cancel();
            setState(() {
              widget.initpage = index;
              stories = HomeCubit.get(context).stories[index].stories!;
              _restartWidget();
            });
          },
          itemBuilder: (context, pageviewindex) {
            return ListView.separated(
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
                                  "${AppUrl.stories}${userinfo[index].email}/${stories[currentStoryIndex].image}")
                              : AspectRatio(
                                  aspectRatio:
                                      videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController!),
                                ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (currentStoryIndex == 0) {
                                      if (widget.initpage != 0) {
                                        pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      stories[currentStoryIndex].video != null
                                          ? videoPlayerController!.dispose()
                                          : null;
                                      timer.cancel();
                                      percentWatched[currentStoryIndex] = 0;

                                      currentStoryIndex--;
                                      percentWatched[currentStoryIndex] = 0;
                                      stories[currentStoryIndex].video != null
                                          ? initvideo()
                                          : _startWatching();
                                    }
                                  });
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
                                      if (userinfo.length - 1 !=
                                          widget.initpage) {
                                        pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      stories[currentStoryIndex].video != null
                                          ? videoPlayerController!.dispose()
                                          : null;
                                      timer.cancel();
                                      percentWatched[currentStoryIndex] = 1;
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
                                      Stringconstants.basicimg(
                                          userinfo[pageviewindex]),
                                      wid: 45,
                                      high: 45,
                                      circular: true),
                                  Components.sizedwd(size: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Components.defText(
                                          text:
                                              "${userinfo[pageviewindex].firstname} ${userinfo[pageviewindex].lastname}",
                                          size: 18),
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
                        Positioned(
                            bottom: 10,
                            right: 2,
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: LikeAnimation(
                                isAnimating: false,
                                child: IconButton(
                                  onPressed: stories[currentStoryIndex].like!
                                      ? null
                                      : () {
                                          HomeCubit.get(context).likestory(
                                              stories[currentStoryIndex].id!);
                                          setState(() {
                                            stories[currentStoryIndex].like =
                                                true;
                                            isAnimating = true;
                                          });
                                        },
                                  icon: Icon(
                                    stories[currentStoryIndex].like!
                                        ? MyFlutterApp.heart
                                        : MyFlutterApp.heart_empty,
                                    color: stories[currentStoryIndex].like!
                                        ? AppColors.red
                                        : AppColors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )),
                        Center(
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: isAnimating ? 1 : 0,
                            child: LikeAnimation(
                              isAnimating: isAnimating,
                              duration: Duration(milliseconds: 400),
                              iconlike: false,
                              End: () {
                                setState(() {
                                  isAnimating = false;
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 100,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox();
                },
                itemCount: stories.length);
          },
          itemCount: userinfo.length,
        ),
      )),
    );
  }
}
