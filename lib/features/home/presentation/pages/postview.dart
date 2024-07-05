import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:iclick/config/network/url.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/componennts/connectivity.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/app_size.dart';
import 'package:iclick/core/utils/app_string.dart';
import 'package:iclick/core/utils/datetime.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/core/utils/relationship.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/widgets/homepagewid.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';

class PostView extends StatelessWidget {
  int id;
  PostView(this.id, {super.key});
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return isOffline(
      widget: BlocProvider(
        create: (context) => HomeCubit()..getpostbyid(id),
        child: BlocConsumer<HomeCubit, HomeState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Components.defText(text: "Post"),
              ),
              body: state is GetPostIDLoading
                  ? Center(
                      child: Components.loadingwidget(),
                    )
                  : Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => AppRoutes.animroutepush(
                                  context: context,
                                  screen: ProfileUserScreen(
                                      HomeCubit.get(context)
                                          .postbyid!
                                          .user!
                                          .id!)),
                              child: Row(
                                children: [
                                  Components.defchachedimg(
                                    Stringconstants.basicimg(
                                        HomeCubit.get(context).postbyid!.user!),
                                    circular: true,
                                    wid: 45,
                                    high: 45,
                                  ),
                                  Components.sizedwd(size: 5),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Components.defText(
                                            text:
                                                "${HomeCubit.get(context).postbyid!.user!.firstname} ${HomeCubit.get(context).postbyid!.user!.lastname}"),
                                        Components.defText(
                                            text: TimeFormate.formatTimeAgo(
                                                DateTime.parse(
                                                    HomeCubit.get(context)
                                                        .postbyid!
                                                        .date!)),
                                            size: 16,
                                            color:
                                                AppColors.grey.withOpacity(0.6))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: HomeCubit.get(context)
                                                .postbyid!
                                                .relationship! !=
                                            "double" &&
                                        HomeCubit.get(context)
                                                .postbyid!
                                                .relationship! !=
                                            "me" &&
                                        HomeCubit.get(context)
                                                .postbyid!
                                                .relationship !=
                                            'follow',
                                    child: InkWell(
                                      onTap: () => HomeCubit.get(context)
                                          .follow(
                                              HomeCubit.get(context).postbyid!,
                                              context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.primary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Components.defText(
                                              text: Relationship.handle(
                                                  HomeCubit.get(context)
                                                      .postbyid!
                                                      .relationship!),
                                              size: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Components.sizedhg(size: 15),
                            Center(
                              child: SizedBox(
                                width: MediaQueryValues(context).width,
                                height: MediaQueryValues(context).width,
                                child: FullScreenWidget(
                                    child: Components.defchachedimg(
                                      "${AppUrl.imageposts}${HomeCubit.get(context).postbyid!.user!.email}/${HomeCubit.get(context).postbyid!.image!}",
                                      fit: BoxFit.fill,
                                    ),
                                    disposeLevel: DisposeLevel.Medium),
                              ),
                            ),
                            Components.sizedhg(size: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => HomeCubit.get(context).likepost(
                                      HomeCubit.get(context).postbyid!,
                                      context),
                                  child: Icon(
                                    HomeCubit.get(context).postbyid!.liked!
                                        ? MyFlutterApp.heart
                                        : MyFlutterApp.heart_empty,
                                    size: 25,
                                    color:
                                        HomeCubit.get(context).postbyid!.liked!
                                            ? AppColors.red
                                            : AppColors.white,
                                  ),
                                ),
                                Components.sizedwd(size: 10),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return commentpostWid(
                                            formstate, id.toString());
                                      },
                                    ).whenComplete(() {
                                      HomeCubit.get(context).commentcon.text =
                                          '';
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
                                  onTap: () => HomeCubit.get(context).sharereel(
                                      HomeCubit.get(context).postbyid!.id!),
                                  child: Icon(
                                    MyFlutterApp.share,
                                    color: AppColors.white,
                                    size: 25,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: Components.defText(
                                      text:
                                          "${HomeCubit.get(context).postbyid!.likes} Likes",
                                      size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
