import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:iclick/features/addpost/presentation/cubit/addpost_cubit.dart';
import 'package:iclick/features/addpost/presentation/widgets/editwid.dart';
import 'package:video_player/video_player.dart';

class UploadReelScreen extends StatefulWidget {
  File videoFile;
  UploadReelScreen(this.videoFile, {super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  late VideoPlayerController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((value) {
        setState(() {
          controller.play();
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddpostCubit, AddpostState>(
      builder: (context, state) {
        AddpostCubit cubit = AddpostCubit.get(context);
        return Scaffold(
          bottomSheet:
              AddpostCubit.get(context).type == 1 || state is UploadReelLoading
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Components.defaultform(
                                controller: cubit.caption,
                                validator: (p0) {},
                                hint: "Caption",
                                focusNode: FocusNode(),
                                fouce: false),
                          ),
                          Components.sizedwd(size: 30),
                          MenuIconWidget(
                            onTap: () => cubit.uploadreel(context),
                            icon: Icons.send,
                          ),
                        ],
                      ),
                    ),
          floatingActionButton: state is UploadStoryLoading
              ? null
              : AddpostCubit.get(context).type != 1
                  ? null
                  : FloatingActionButton(
                      onPressed: () => cubit.uploadStory(context, 1,
                          video: widget.videoFile.path),
                      child: Icon(
                        Icons.send,
                        color: AppColors.black,
                      ),
                    ),
          body: SafeArea(
            child: state is UploadStoryLoading || state is UploadReelLoading
                ? Center(
                    child: Components.loadingwidget(),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                          width: double.infinity,
                          child: InkWell(
                            onTap: controller.value.isPlaying
                                ? () {
                                    setState(() {
                                      controller.pause();
                                    });
                                  }
                                : () {
                                    setState(() {
                                      controller.play();
                                    });
                                  },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                                Visibility(
                                  visible: !controller.value.isPlaying,
                                  child: Icon(
                                    MyFlutterApp.play,
                                    size: 30,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
