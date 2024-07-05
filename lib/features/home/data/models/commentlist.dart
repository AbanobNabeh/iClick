import 'package:flutter/material.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/dialog.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/reels/data/models/commentmodel.dart';
import 'package:iclick/features/reels/data/models/repliesmodel.dart';
import 'package:iclick/features/reels/presentation/cubit/reels_cubit.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';
import 'package:readmore/readmore.dart';

// ignore: camel_case_types
class commentList {
  Widget comments({
    required BuildContext context,
    required bool loading,
    required Function() addcoment,
    required bool isrepaly,
    required List<CommentModel> comment,
    required GlobalKey<FormState> formstate,
    required TextEditingController controller,
    ReelsCubit? reelsCubit,
    HomeCubit? homeCubit,
    required double height,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? Center(
                child: Components.loadingwidget(),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.white),
                      ),
                      Components.sizedhg(size: 10),
                      Components.defText(
                          text:
                              '${Stringconstants.formatNumber(comment.length.toString())} Comments',
                          size: 16),
                      Flexible(
                        child: comment.isEmpty
                            ? Center(
                                child:
                                    Components.defText(text: 'No Comment Yet'),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  return commentt(
                                    homeCubit: homeCubit,
                                    reelsCubit: reelsCubit,
                                    repliesModel: reelsCubit == null
                                        ? homeCubit!.replies
                                        : reelsCubit.replies,
                                    comment: comment[index],
                                    context: context,
                                    deletecomm: () => reelsCubit == null
                                        ? homeCubit!.deletecomment(
                                            comment[index].id!,
                                            context,
                                            comment[index].link!)
                                        : reelsCubit.deletecomment(
                                            comment[index].id!,
                                            context,
                                            comment[index].link!),
                                    addreplay: () => reelsCubit == null
                                        ? homeCubit!.replay(comment[index])
                                        : reelsCubit.replay(comment[index]),
                                    likecomment: () => reelsCubit == null
                                        ? homeCubit!.likecomment(comment[index])
                                        : reelsCubit
                                            .likecomment(comment[index]),
                                    getreplaies: () => reelsCubit == null
                                        ? homeCubit!
                                            .getreplies(comment[index].id!)
                                        : reelsCubit
                                            .getreplies(comment[index].id!),
                                    showreplies: reelsCubit == null
                                        ? homeCubit!.showreplies
                                        : reelsCubit.showreplies,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Components.sizedhg(size: 10);
                                },
                                itemCount: comment.length),
                      ),
                      Components.sizedhg(size: 70)
                    ],
                  ),
                  Positioned(
                      bottom: MediaQueryValues(context).bottom,
                      left: 1,
                      right: 1,
                      child: Form(
                        key: formstate,
                        child: isrepaly
                            ? addcomment(
                                formstate: formstate,
                                comment: controller,
                                addcoment: addcoment)
                            : replay(
                                replaydata: reelsCubit == null
                                    ? homeCubit!.isreplay!
                                    : reelsCubit.isreplay!,
                                formstate: formstate,
                                comment: controller,
                                cancelreplay: () => reelsCubit == null
                                    ? homeCubit!.replay(null)
                                    : reelsCubit.replay(null),
                                addreplay: () => reelsCubit == null
                                    ? homeCubit!.addreplay()
                                    : reelsCubit.addreplay(),
                              ),
                      )),
                ],
              ),
      ),
    );
  }

  Widget addcomment({
    required GlobalKey<FormState> formstate,
    required TextEditingController comment,
    required Function() addcoment,
  }) {
    return Components.defaultform(
        suffixIcon: Icons.send,
        suffixIcontap: () {
          if (formstate.currentState!.validate()) {
            addcoment();
          }
        },
        controller: comment,
        validator: (p0) {
          if (p0!.isEmpty) {
            return "Comment Empty....";
          }
          return null;
        },
        hint: "Add Comment...",
        focusNode: FocusNode(),
        fouce: false);
  }

  Widget replay(
      {required GlobalKey<FormState> formstate,
      required TextEditingController comment,
      required Function() cancelreplay,
      required Function() addreplay,
      required CommentModel replaydata}) {
    return Components.defaultform(
        suffixIcon: Icons.send,
        prefixIcon: Icons.close,
        prefixIcontap: cancelreplay,
        suffixIcontap: () {
          if (formstate.currentState!.validate()) {
            addreplay();
          }
        },
        controller: comment,
        validator: (p0) {
          if (p0!.isEmpty) {
            return "Replay Empty....";
          }
          return null;
        },
        hint: "Replay To ${replaydata.userinfo!.firstname}...",
        focusNode: FocusNode(),
        fouce: false);
  }

  Widget commentt({
    required CommentModel comment,
    required BuildContext context,
    required Function() deletecomm,
    required Function() addreplay,
    required Function() likecomment,
    required Function() getreplaies,
    required List<RepliesModel> repliesModel,
    ReelsCubit? reelsCubit,
    HomeCubit? homeCubit,
    int? showreplies,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => AppRoutes.animroutepush(
              context: context,
              screen: ProfileUserScreen(comment.userinfo!.id!)),
          child: Components.defchachedimg(
              Stringconstants.basicimg(comment.userinfo),
              circular: true,
              wid: 45,
              high: 45),
        ),
        Components.sizedwd(size: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onLongPress: SplachscreenCubit.get(context)
                            .profile!
                            .id
                            .toString() ==
                        comment.iduser
                    ? () => showconfrimdeleteitem(context,
                        title: "Are you sure you want to delete the comment?",
                        onPressed: deletecomm)
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Components.defText(
                              text:
                                  "${comment.userinfo!.firstname} ${comment.userinfo!.lastname}",
                              size: 16,
                              color: AppColors.grey.withOpacity(0.5)),
                          SizedBox(
                            child: ReadMoreText(
                              comment.comment!,
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              colorClickableText: AppColors.primary,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                          Components.sizedhg(size: 5),
                          Row(
                            children: [
                              Components.defText(
                                  text: TimeFormate.formatTimeAgo(
                                      DateTime.parse(comment.date!)),
                                  size: 14,
                                  color: AppColors.grey.withOpacity(0.5)),
                              Components.sizedwd(size: 8),
                              InkWell(
                                onTap: addreplay,
                                child: Components.defText(
                                    text: 'Replay',
                                    size: 14,
                                    color: AppColors.grey.withOpacity(0.7)),
                              )
                            ],
                          ),
                          Components.sizedhg(size: 8),
                        ],
                      ),
                    ),
                    Components.sizedwd(size: 15),
                    Column(
                      children: [
                        InkWell(
                          onTap: likecomment,
                          child: Icon(
                            comment.liked!
                                ? MyFlutterApp.heart
                                : MyFlutterApp.heart_empty,
                            color: comment.liked!
                                ? AppColors.red
                                : AppColors.secblack,
                          ),
                        ),
                        Components.defText(
                            text: comment.like!,
                            size: 16,
                            color: AppColors.grey.withOpacity(0.5)),
                      ],
                    ),
                    Components.sizedwd(size: 3),
                  ],
                ),
              ),
              showreplies == comment.id || comment.replies == 0
                  ? SizedBox()
                  : InkWell(
                      onTap: getreplaies,
                      child: Components.defText(
                          text: 'Show ${comment.replies} Replis',
                          size: 16,
                          color: AppColors.grey.withOpacity(0.8)),
                    ),
              showreplies == comment.id
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return repliesitem(
                            context: context,
                            repliesModel: repliesModel[index],
                            reelsCubit: reelsCubit,
                            homeCubit: homeCubit);
                      },
                      separatorBuilder: (context, index) {
                        return Components.sizedhg();
                      },
                      itemCount: repliesModel.length)
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget repliesitem({
    required BuildContext context,
    required RepliesModel repliesModel,
    ReelsCubit? reelsCubit,
    HomeCubit? homeCubit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => AppRoutes.animroutepush(
              context: context,
              screen: ProfileUserScreen(repliesModel.userinfo!.id!)),
          child: Align(
            alignment: Alignment.topRight,
            child: Components.defchachedimg(
                Stringconstants.basicimg(repliesModel.userinfo),
                circular: true,
                wid: 45,
                high: 45),
          ),
        ),
        Components.sizedwd(size: 7),
        Expanded(
          child: InkWell(
            onLongPress: SplachscreenCubit.get(context)
                        .profile!
                        .id
                        .toString() ==
                    repliesModel.iduser
                ? () => showconfrimdeleteitem(context,
                    title: "Are you sure you want to delete the Replay ?",
                    onPressed: () => reelsCubit == null
                        ? homeCubit!.deletereplay(repliesModel.id!, context)
                        : reelsCubit.deletereplay(repliesModel.id!, context))
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Components.defText(
                          text:
                              "${repliesModel.userinfo!.firstname} ${repliesModel.userinfo!.lastname}",
                          size: 16,
                          color: AppColors.grey.withOpacity(0.5)),
                      SizedBox(
                        child: ReadMoreText(
                          repliesModel.repaly!,
                          trimMode: TrimMode.Line,
                          trimLines: 2,
                          colorClickableText: AppColors.primary,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Components.defText(
                              text: TimeFormate.formatTimeAgo(
                                  DateTime.parse(repliesModel.date!)),
                              size: 14,
                              color: AppColors.grey.withOpacity(0.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        reelsCubit == null
                            ? homeCubit!.likereplay(repliesModel)
                            : reelsCubit.likereplay(repliesModel);
                      },
                      child: Icon(
                        repliesModel.liked!
                            ? MyFlutterApp.heart
                            : MyFlutterApp.heart_empty,
                        color: repliesModel.liked!
                            ? AppColors.red
                            : AppColors.secblack,
                      ),
                    ),
                    Components.defText(
                        text: repliesModel.like!,
                        size: 16,
                        color: AppColors.grey.withOpacity(0.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
