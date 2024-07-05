import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 50,
                height: 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.white),
              ),
              Components.sizedhg(size: 10),
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      height: 200,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              Components.sizedhg(size: 10),
              VideoProgressIndicator(
                _controller,
                colors: VideoProgressColors(
                  playedColor: AppColors.primary,
                  backgroundColor: AppColors.white,
                ),
                allowScrubbing: true,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: AppColors.white,
                    icon: Icon(Icons.replay_10),
                    onPressed: () {
                      final newPosition =
                          _controller.value.position - Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? MyFlutterApp.pause : MyFlutterApp.play,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        _isPlaying ? _controller.play() : _controller.pause();
                      });
                    },
                  ),
                  IconButton(
                    color: AppColors.white,
                    icon: Icon(Icons.forward_10),
                    onPressed: () {
                      final newPosition =
                          _controller.value.position + Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
