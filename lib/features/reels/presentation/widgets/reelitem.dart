import 'package:flutter/material.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/asset_manger.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/core/utils/riveutils.dart';
import 'package:iclick/features/follow/presentation/cubit/follow_cubit.dart';
import 'package:iclick/features/reels/data/models/reelmodel.dart';
import 'package:iclick/core/utils/like.dart';
import 'package:iclick/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:iclick/features/reels/presentation/widgets/items.dart';
import 'package:readmore/readmore.dart';
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ReelsItem extends StatefulWidget {
  ReelModel reels;
  ReelsCubit cubit;
  ReelsItem(this.reels, this.cubit, {super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController controller;
  bool play = true;
  bool isAnimating = false;
  bool followanim = false;
  late SMIBool searchtigger;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  void initState() {
    print("objectdasdasdas");
    print(
        '${AppUrl.imagereels}${widget.reels.user!.email}${widget.reels.video}');
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(
        '${AppUrl.imagereels}${widget.reels.user!.email}/${widget.reels.video}'))
      ..initialize().then((value) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(widget.cubit.volumedown ? 0 : 1);
          controller.play();
        });
      }).catchError((error) {
        print(
            'Video player encountered an error: ${controller.value.errorDescription}');
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isAnimating = true;
            });
          },
          onTap: () {
            setState(() {
              play = !play;
            });
            if (play) {
              controller.play();
            } else {
              controller.pause();
            }
          },
        ),
        Center(
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                isAnimating = true;
              });
            },
            onTap: () {
              setState(() {
                play = !play;
              });
              if (play) {
                controller.play();
              } else {
                controller.pause();
              }
            },
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                : CircularProgressIndicator(),
          ),
        ),
        if (!play)
          Center(
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 35,
              child: Icon(
                Icons.play_arrow,
                size: 35,
                color: AppColors.white,
              ),
            ),
          ),
        Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isAnimating ? 1 : 0,
            child: LikeAnimation(
              isAnimating: isAnimating,
              duration: Duration(milliseconds: 400),
              iconlike: false,
              End: () {
                widget.reels.liked!
                    ? null
                    : ReelsCubit.get(context).likereel(widget.reels, context);
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
        Center(
          child: AnimatedOpacity(
            duration: Duration(seconds: 2),
            opacity: followanim ? 1 : 0,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.primary,
              child: RiveAnimation.asset(
                IMGManger.riveAssets,
                artboard: "USER",
                onInit: (p0) {
                  searchtigger = RiveUtils.getRiveInput(p0,
                      stateMachineName: 'USER_Interactivity');
                },
              ),
            ),
            onEnd: () {
              setState(() {
                followanim = false;
                searchtigger.change(false);
              });
            },
          ),
        ),
        Positioned(
          bottom: 50,
          right: 10,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                  ),
                  Components.defchachedimg(
                      Stringconstants.basicimg(widget.reels.user),
                      circular: true,
                      wid: 50,
                      high: 50),
                  widget.reels.relationship == 'nothing' ||
                          widget.reels.relationship == 'following'
                      ? Column(
                          children: [
                            Container(
                              height: 35,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchtigger.change(true);
                                    followanim = true;
                                    widget.reels.relationship = 'follow';
                                  });
                                  FollowCubit.get(context)
                                      .follow(widget.reels.user!, context);
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    MyFlutterApp.plus,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                ))
                          ],
                        )
                      : SizedBox()
                ],
              ),
              Components.sizedhg(size: 15),
              LikeAnimation(
                isAnimating: isAnimating,
                child: IconButton(
                  onPressed: () {
                    widget.reels.liked! ? null : isAnimating = true;
                    ReelsCubit.get(context).likereel(widget.reels, context);
                  },
                  icon: Icon(
                    widget.reels.liked!
                        ? MyFlutterApp.heart
                        : MyFlutterApp.heart_empty,
                    color:
                        widget.reels.liked! ? AppColors.red : AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              Components.defText(
                  text: Stringconstants.formatNumber('${widget.reels.like}'),
                  size: 16),
              Components.sizedhg(size: 15),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return bottomcommentshet(widget.reels, formstate);
                    },
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      MyFlutterApp.comment_empty,
                      color: AppColors.white,
                      size: 28,
                    ),
                    Components.sizedhg(size: 5),
                    Components.defText(
                        text: Stringconstants.formatNumber(
                            widget.reels.comment.toString()),
                        size: 16),
                  ],
                ),
              ),
              Components.sizedhg(size: 15),
              GestureDetector(
                onTap: () => widget.cubit.sharereel(widget.reels.id!),
                child: Icon(
                  MyFlutterApp.share,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
              Components.sizedhg(size: 15),
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.cubit.volumedown = !widget.cubit.volumedown;
                      controller.setVolume(widget.cubit.volumedown ? 0 : 1);
                    });
                  },
                  icon: Icon(
                    widget.cubit.volumedown
                        ? IconBroken.Volume_Off
                        : IconBroken.Volume_Up,
                    color: AppColors.white,
                  ))
            ],
          ),
        ),
        widget.reels.caption == null
            ? SizedBox()
            : Positioned(
                bottom: 10,
                left: 5,
                right: 0,
                child: SizedBox(
                  width: MediaQueryValues(context).width / 1.5,
                  child: ReadMoreText(
                    '${widget.reels.caption}',
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    colorClickableText: AppColors.primary,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
      ],
    );
  }
}
