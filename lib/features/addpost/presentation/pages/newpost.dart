import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/config/routes/app_routes.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/addpost/presentation/pages/uploadpost.dart';
import 'package:iclick/features/addpost/presentation/widgets/gallarywid.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddpostCubit, AddpostState>(
      builder: (context, state) {
        AddpostCubit cubit = AddpostCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Components.defText(
                text: "IClick",
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                size: 30),
            centerTitle: true,
            actions: [
              cubit.type == 0
                  ? TextButton(
                      onPressed: () async {
                        AppRoutes.animroutepush(
                            context: context, screen: const UploadPost());
                      },
                      child: Components.defText(
                          text: 'Next',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold))
                  : SizedBox()
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                PageView(
                  controller: PageController(),
                  onPageChanged: (value) {
                    if (value == 0) {
                      cubit.getimages();
                    } else if (value == 1) {
                      cubit.getmedia();
                    } else if (value == 2) {
                      cubit.getvideos();
                    }
                  },
                  children: [
                    state is GetImageLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : galleryWid(cubit: cubit, context: context),
                    state is GetMediaLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : media(cubit: cubit, context: context),
                    state is GetVideosLoading
                        ? Center(
                            child: Components.loadingwidget(),
                          )
                        : reelWid(cubit: cubit, context: context)
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  bottom: 10,
                  right: cubit.type == 0
                      ? 50
                      : cubit.type == 1
                          ? 80
                          : 100,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secblack,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Post ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: cubit.type == 0
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Story ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: cubit.type == 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Reels ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: cubit.type == 2
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
