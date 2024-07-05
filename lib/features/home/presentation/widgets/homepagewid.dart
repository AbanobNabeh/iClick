import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/core/utils/relationship.dart';
import 'package:iclick/features/auth/data/models/usermodel.dart';
import 'package:iclick/features/home/data/models/commentlist.dart';
import 'package:iclick/features/home/data/models/postmodel.dart';
import 'package:iclick/features/home/data/models/viewstorymodel.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/pages/mystory.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/home/presentation/pages/story.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:badges/badges.dart' as badges;

Widget bottomnb(HomeCubit cubit, BuildContext context) {
  return BottomAppBar(
    color: AppColors.black,
    height: 60,
    elevation: 20,
    shape: CircularNotchedRectangle(),
    child: Row(
      children: [
        itemicon(
            icon: IconBroken.Home, cubit: cubit, index: 0, context: context),
        itemicon(
            icon: IconBroken.Play, cubit: cubit, index: 1, context: context),
        itemicon(
            icon: IconBroken.Plus, cubit: cubit, index: 2, context: context),
        badges.Badge(
          position: badges.BadgePosition.topEnd(end: 3),
          showBadge: SplachscreenCubit.get(context).notifiyunseen != 0,
          badgeContent: Text("${SplachscreenCubit.get(context).notifiyunseen}"),
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          child: IconButton(
              onPressed: () => cubit.changeindex(3, context),
              icon: Icon(
                IconBroken.Notification,
                color: cubit.currentindex == 3
                    ? AppColors.primary
                    : AppColors.secblack,
              )),
        ),
        itemicon(
            icon: IconBroken.Profile, cubit: cubit, index: 4, context: context),
      ],
    ),
  );
}

Widget itemicon(
    {required IconData icon,
    required HomeCubit cubit,
    required int index,
    required BuildContext context}) {
  return Expanded(
    child: IconButton(
      icon: Icon(
        icon,
        color: cubit.currentindex == index
            ? AppColors.primary
            : AppColors.secblack,
      ),
      onPressed: () {
        cubit.changeindex(index, context);
      },
    ),
  );
}

Widget storiesWid(List<UserModel> user) {
  return Container(
    height: 120,
    child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () => showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Hero(tag: "test", child: StoryScreen(index)),
                    ),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: user[index].watch!
                            ? Colors.transparent
                            : AppColors.primary,
                      ),
                      Components.defchachedimg(
                          Stringconstants.basicimg(user[index]),
                          circular: true,
                          wid: 80,
                          high: 80)
                    ],
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    child: Center(
                        child: Components.defText(
                            text: "${user[index].firstname}", size: 16)),
                  ),
                ],
              ));
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: user.length),
  );
}

Widget mystories(BuildContext context) {
  return InkWell(
    onTap: () => showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: 30),
        child: MystoryScreen(),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Components.defchachedimg(
                Stringconstants.basicimg(
                    SplachscreenCubit.get(context).profile),
                circular: true,
                wid: 80,
                high: 80)
          ],
        ),
        Container(
          width: 80,
          height: 30,
          child:
              Center(child: Components.defText(text: "Your Story", size: 16)),
        ),
      ],
    ),
  );
}

Widget viewersstory(List<ViewStoryModel> story, BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQueryValues(context).height / 2,
    child: BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return state is GetViewersLoading
            ? Center(
                child: Components.loadingwidget(),
              )
            : Column(
                children: [
                  Components.sizedhg(size: 10),
                  Container(
                    width: 100,
                    height: 5,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
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
                                  Components.defText(text: " ${story.length}"),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Row(
                                      children: [
                                        Components.defchachedimg(
                                            Stringconstants.basicimg(
                                                story[index].getuser),
                                            wid: 55,
                                            high: 55,
                                            circular: true),
                                        Components.sizedwd(size: 10),
                                        Components.defText(
                                            text:
                                                "${story[index].getuser!.firstname} ${story[index].getuser!.lastname}",
                                            size: 16),
                                        Spacer(),
                                        story[index].like! == '1'
                                            ? Icon(
                                                MyFlutterApp.heart,
                                                color: AppColors.red,
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                itemCount: story.length),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },
      listener: (context, state) {},
    ),
  );
}

Widget posts(PostModel post, BuildContext context) {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: AppColors.secblack),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => AppRoutes.animroutepush(
                    context: context,
                    screen: ProfileUserScreen(post.user!.id!)),
                child: Components.defchachedimg(
                  Stringconstants.basicimg(post.user),
                  circular: true,
                  wid: 45,
                  high: 45,
                ),
              ),
              Components.sizedwd(size: 5),
              Expanded(
                child: InkWell(
                  onTap: () => AppRoutes.animroutepush(
                      context: context,
                      screen: ProfileUserScreen(post.user!.id!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Components.defText(
                          text:
                              "${post.user!.firstname} ${post.user!.lastname}"),
                      Components.defText(
                          text: TimeFormate.formatTimeAgo(
                              DateTime.parse(post.date!)),
                          size: 16,
                          color: AppColors.grey.withOpacity(0.6))
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: post.relationship! != "double" &&
                    post.relationship! != "me" &&
                    post.relationship != 'follow',
                child: InkWell(
                  onTap: () => HomeCubit.get(context).follow(post, context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Components.defText(
                          text: Relationship.handle(post.relationship!),
                          size: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Components.sizedhg(size: 15),
          Center(
            child: SizedBox(
              width: MediaQueryValues(context).width,
              height: MediaQueryValues(context).width,
              child: FullScreenWidget(
                  child: Components.defchachedimg(
                    "${AppUrl.imageposts}${post.user!.email}/${post.image}",
                    fit: BoxFit.fill,
                  ),
                  disposeLevel: DisposeLevel.Medium),
            ),
          ),
          Components.sizedhg(size: 10),
          Row(
            children: [
              InkWell(
                onTap: () => HomeCubit.get(context).likepost(post, context),
                child: Icon(
                  post.liked! ? MyFlutterApp.heart : MyFlutterApp.heart_empty,
                  size: 25,
                  color: post.liked! ? AppColors.red : AppColors.white,
                ),
              ),
              Components.sizedwd(size: 10),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return commentpostWid(formstate, post.id.toString());
                    },
                  ).whenComplete(() {
                    HomeCubit.get(context).commentcon.text = '';
                    HomeCubit.get(context).replies = [];
                    HomeCubit.get(context).showreplies = null;
                  });
                },
                child: Icon(
                  MyFlutterApp.comment_empty,
                  color: AppColors.white,
                  size: 25,
                ),
              ),
              Components.sizedwd(size: 10),
              InkWell(
                onTap: () => HomeCubit.get(context).sharereel(post.id!),
                child: Icon(
                  MyFlutterApp.share,
                  color: AppColors.white,
                  size: 25,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {},
                child:
                    Components.defText(text: "${post.likes} Likes", size: 18),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget commentpostWid(GlobalKey<FormState> formstate, String idpost) {
  return BlocProvider(
    create: (context) => HomeCubit()..getcomment(idpost),
    child: BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return commentList().comments(
          homeCubit: HomeCubit.get(context),
          height: MediaQueryValues(context).height - 80,
          addcoment: () => cubit.addcomment(idpost.toString(), context),
          context: context,
          loading: state is GetCommentLoading,
          comment: HomeCubit.get(context).comments,
          controller: cubit.commentcon,
          formstate: formstate,
          isrepaly: cubit.isreplay == null,
        );
      },
      listener: (context, state) {},
    ),
  );
}
