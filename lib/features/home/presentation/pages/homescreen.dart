import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/features/home/presentation/cubit/home_cubit.dart';
import 'package:iclick/features/home/presentation/widgets/homepagewid.dart';
import 'package:iclick/features/home/presentation/widgets/loadingwid.dart';
import 'package:iclick/features/splachscreen/presentation/cubit/splachscreen_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = HomeCubit.get(context).controllerscroll;
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        HomeCubit.get(context).pagePosts = HomeCubit.get(context).pagePosts + 1;
        HomeCubit.get(context).getposts();
      }
    });
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.secblack,
            onRefresh: () async {
              HomeCubit.get(context).pagePosts = 1;
              HomeCubit.get(context).getstories();
              HomeCubit.get(context).getposts();
              SplachscreenCubit.get(context).getprofile();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state is GetPostsLoading
                      ? Expanded(child: lodaingPost())
                      : Expanded(
                          child: ListView.separated(
                              controller: controller,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return state is GetStoriesLoading
                                      ? loadingStories()
                                      : Visibility(
                                          visible: HomeCubit.get(context)
                                                  .stories
                                                  .isNotEmpty ||
                                              HomeCubit.get(context)
                                                  .mystory
                                                  .isNotEmpty,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                HomeCubit.get(context)
                                                        .mystory
                                                        .isEmpty
                                                    ? SizedBox()
                                                    : mystories(context),
                                                Components.sizedwd(size: 10),
                                                storiesWid(
                                                    HomeCubit.get(context)
                                                        .stories),
                                              ],
                                            ),
                                          ),
                                        );
                                } else {
                                  return posts(
                                      HomeCubit.get(context).posts[index - 1],
                                      context);
                                }
                              },
                              separatorBuilder: (context, index) {
                                return Components.sizedhg();
                              },
                              itemCount:
                                  HomeCubit.get(context).posts.length + 1),
                        ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
