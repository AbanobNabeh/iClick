import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/core/utils/relationship.dart';
import 'package:iclick/features/chat/presentation/pages/chatscreen.dart';
import 'package:iclick/features/follow/presentation/pages/followersscreen.dart';
import 'package:iclick/features/home/presentation/pages/postview.dart';
import 'package:iclick/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:iclick/features/profile/presentation/widgets/profilewidget.dart';
import 'package:iclick/features/profile/presentation/widgets/videoitem.dart';
import 'package:iclick/features/reels/presentation/pages/rellview.dart';

import '../../../splachscreen/presentation/cubit/splachscreen_cubit.dart';

// ignore: must_be_immutable
class ProfileUserScreen extends StatelessWidget {
  int iduser;
  ProfileUserScreen(this.iduser, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileUser(iduser),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        builder: (context, state) {
          ProfileCubit cubit = ProfileCubit.get(context);
          ScrollController controller = cubit.controllerscroll;
          bool checkme = SplachscreenCubit.get(context).profile!.id == iduser;
          controller.addListener(() {
            if (controller.position.maxScrollExtent == controller.offset) {
              if (cubit.indexpage == 0) {
                cubit.postspage = cubit.postspage + 1;
                cubit.getPostsUser(iduser);
              } else {
                cubit.reelspage = cubit.reelspage + 1;
                cubit.getReelsUser(iduser);
              }
            }
          });
          return state is GetProfileUserLoading
              ? Center(
                  child: Components.loadingwidget(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    cubit.getProfileUser(iduser);
                  },
                  child: Scaffold(
                    appBar: checkme
                        ? myAppbar(state, context,
                            ProfileCubit.get(context).profileUser)
                        : AppBar(
                            title: Components.defText(
                                text: state is GetProfileUserLoading
                                    ? "Loading.."
                                    : "${cubit.profileUser.firstname} ${cubit.profileUser.lastname}"),
                            actions: [
                              IconButton(
                                  onPressed: () => cubit.shareprofile(iduser),
                                  icon: const Icon(MyFlutterApp.share))
                            ],
                          ),
                    body: state is GetProfileUserLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : SingleChildScrollView(
                            controller: cubit.controllerscroll,
                            child: Column(
                              children: [
                                Components.sizedhg(),
                                Components.defchachedimg(
                                    Stringconstants.basicimg(cubit.profileUser),
                                    circular: true,
                                    wid: 100,
                                    high: 100),
                                Components.sizedhg(size: 10),
                                Components.defText(
                                    text: "@${cubit.profileUser.username}"),
                                Components.sizedhg(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Components.defText(
                                            text: Stringconstants.formatNumber(
                                                cubit.profileUser.following!)),
                                        Components.defText(
                                            text: "Following",
                                            size: 16,
                                            color: AppColors.grey
                                                .withOpacity(0.5)),
                                      ],
                                    ),
                                    Components.sizedwd(size: 10),
                                    Container(
                                      width: 2,
                                      height: 27,
                                      color: AppColors.secblack,
                                    ),
                                    Components.sizedwd(size: 10),
                                    InkWell(
                                      onTap: () => AppRoutes.animroutepush(
                                          context: context,
                                          screen: FollowersScreen(
                                              iduser.toString(), true)),
                                      child: Column(
                                        children: [
                                          Components.defText(
                                              text:
                                                  Stringconstants.formatNumber(
                                                      cubit.profileUser
                                                          .followers!)),
                                          Components.defText(
                                              text: "Followers",
                                              size: 16,
                                              color: AppColors.grey
                                                  .withOpacity(0.5)),
                                        ],
                                      ),
                                    ),
                                    Components.sizedwd(size: 10),
                                    Container(
                                      width: 2,
                                      height: 27,
                                      color: AppColors.secblack,
                                    ),
                                    Components.sizedwd(size: 10),
                                    Column(
                                      children: [
                                        Components.defText(
                                            text: Stringconstants.formatNumber(
                                                cubit.profileUser.countposts
                                                    .toString())),
                                        Components.defText(
                                            text: "Posts",
                                            size: 16,
                                            color: AppColors.grey
                                                .withOpacity(0.5)),
                                      ],
                                    )
                                  ],
                                ),
                                Components.sizedhg(size: 10),
                                checkme
                                    ? SizedBox()
                                    : cubit.profileUser.relationship == "double"
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Components.defButton(
                                                  text: "Message",
                                                  onTap: () =>
                                                      AppRoutes.animroutepush(
                                                          context: context,
                                                          screen: ChatScreen(
                                                              iduser)),
                                                  width: 100,
                                                  border: 12),
                                              Components.sizedwd(size: 15),
                                              InkWell(
                                                onTap: () =>
                                                    cubit.unfollowuser(),
                                                child: Container(
                                                  width: 45,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: AppColors.white,
                                                  ),
                                                  child: Icon(
                                                    MyFlutterApp.user_times,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : cubit.profileUser.relationship ==
                                                "follow"
                                            ? Components.defButton(
                                                text: Relationship.handle(cubit
                                                    .profileUser.relationship!),
                                                onTap: () =>
                                                    cubit.unfollowuser(),
                                                width: 120,
                                                border: 12)
                                            : Components.defButton(
                                                text: Relationship.handle(cubit
                                                    .profileUser.relationship!),
                                                onTap: () =>
                                                    cubit.followuser(context),
                                                width: 120,
                                                border: 12),
                                Components.sizedhg(size: 10),
                                Visibility(
                                  visible: cubit.profileUser.bio != null,
                                  child: Components.defText(
                                      text: cubit.profileUser.bio.toString(),
                                      size: 16,
                                      textAlign: TextAlign.center,
                                      lines: 2),
                                ),
                                Components.sizedhg(size: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible:
                                          cubit.profileUser.instagram != null,
                                      child: IconButton(
                                          onPressed: () => cubit.launchURL(
                                              "https://www.instagram.com/${cubit.profileUser.instagram}"),
                                          icon: Icon(
                                            MyFlutterApp.instagram,
                                            color: AppColors.red,
                                          )),
                                    ),
                                    Visibility(
                                      visible:
                                          cubit.profileUser.facebook != null,
                                      child: IconButton(
                                          onPressed: () => cubit.launchURL(
                                              "https://www.facebook.com//${cubit.profileUser.facebook}"),
                                          icon: Icon(
                                            MyFlutterApp.facebook,
                                            color: AppColors.red,
                                          )),
                                    ),
                                  ],
                                ),
                                Components.sizedhg(size: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: cubit.indexpage != 0
                                            ? () => cubit.changeIndex(0, iduser)
                                            : null,
                                        child: Container(
                                          height: 40,
                                          child: Center(
                                            child: Icon(
                                              MyFlutterApp.file_image,
                                              color: cubit.indexpage == 0
                                                  ? AppColors.primary
                                                  : AppColors.secblack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: cubit.indexpage != 1
                                            ? () => cubit.changeIndex(1, iduser)
                                            : null,
                                        child: Container(
                                          height: 40,
                                          child: Center(
                                            child: Icon(
                                              MyFlutterApp.video,
                                              color: cubit.indexpage == 1
                                                  ? AppColors.primary
                                                  : AppColors.secblack,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        color: cubit.indexpage == 0
                                            ? AppColors.primary
                                            : AppColors.secblack,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 3,
                                        color: cubit.indexpage == 1
                                            ? AppColors.primary
                                            : AppColors.secblack,
                                      ),
                                    ),
                                  ],
                                ),
                                cubit.indexpage == 1
                                    ? GestureDetector(
                                        onHorizontalDragEnd:
                                            (DragEndDetails details) {
                                          if (details
                                                  .velocity.pixelsPerSecond.dx >
                                              0) {
                                            cubit.changeIndex(0, iduser);
                                          }
                                        },
                                        child: state is GetReelsUserLoading
                                            ? Center(
                                                child:
                                                    Components.loadingwidget(),
                                              )
                                            : GridView.builder(
                                                itemCount: cubit.reels.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 1,
                                                  crossAxisSpacing: 2,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () =>
                                                        AppRoutes.animroutepush(
                                                            context: context,
                                                            screen:
                                                                ReelViewScreen(
                                                                    cubit
                                                                        .reels[
                                                                            index]
                                                                        .id!)),
                                                    child: VideoGridItem(
                                                        chat: false,
                                                        videoUrl:
                                                            "${AppUrl.imagereels}${cubit.profileUser.email}/${cubit.reels[index].video!}"),
                                                  );
                                                },
                                              ),
                                      )
                                    : GestureDetector(
                                        onHorizontalDragEnd:
                                            (DragEndDetails details) {
                                          if (details
                                                  .velocity.pixelsPerSecond.dx <
                                              0) {
                                            cubit.changeIndex(1, iduser);
                                          }
                                        },
                                        child: state is GetPostsUserLoading
                                            ? Center(
                                                child:
                                                    Components.loadingwidget(),
                                              )
                                            : GridView.builder(
                                                itemCount: cubit.posts.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 1,
                                                  crossAxisSpacing: 2,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () =>
                                                        AppRoutes.animroutepush(
                                                            context: context,
                                                            screen: PostView(
                                                                cubit
                                                                    .posts[
                                                                        index]
                                                                    .id!)),
                                                    child: Components
                                                        .defchachedimg(
                                                      "${AppUrl.imageposts}${cubit.profileUser.email}/${cubit.posts[index].image!}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                              ],
                            ),
                          ),
                  ),
                );
        },
        listener: (context, state) {},
      ),
    );
  }
}
