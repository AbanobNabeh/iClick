import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:video_player/video_player.dart';

class VideoGridItem extends StatefulWidget {
  final videoUrl;
  final bool chat;
  const VideoGridItem({super.key, required this.videoUrl, required this.chat});

  @override
  _VideoGridItemState createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.chat) {
      _controller = VideoPlayerController.file(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? widget.chat
            ? InkWell(
                onTap: _controller.value.isPlaying
                    ? () {
                        setState(() {
                          _controller.pause();
                        });
                      }
                    : () {
                        setState(() {
                          _controller.play();
                        });
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Visibility(
                      visible: !_controller.value.isPlaying,
                      child: Icon(
                        MyFlutterApp.play,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
        : Center(child: Components.loadingwidget());
  }
}
