import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({required this.video, Key? key}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  Duration currentPosition = Duration();

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  initializeController() async {
    videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoPlayerController!.initialize();

    videoPlayerController!.addListener(() {
      final currentPosition = videoPlayerController!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return CircularProgressIndicator();
    }
    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(
            videoPlayerController!,
          ),
          _Controls(
            onPlayPressed: onPlayPressed,
            onReversPressed: onReversPressed,
            onForwardPressed: onForwardPressed,
            isPlaying: videoPlayerController!.value.isPlaying,
          ),
          _NewVideo(
            onPressed: onNewVideoPressed,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: currentPosition.inSeconds.toDouble(),
                      onChanged: (double val) {
                        videoPlayerController!.seekTo(
                          Duration(
                            seconds: val.toInt(),
                          ),
                        );
                        setState(() {
                          currentPosition = Duration(seconds: val.toInt());
                        });
                      },
                      max: videoPlayerController!.value.duration.inSeconds
                          .toDouble(),
                      min: 0,
                    ),
                  ),
                  Text(
                    '${videoPlayerController!.value.duration.inMinutes}:${(videoPlayerController!.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onPlayPressed() {
    // 1.이미 실행중이면 중지
    // 2.실행중이 아니면 실행
    setState(() {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
    });
  }

  void onNewVideoPressed() {}

  void onReversPressed() {
    final currentPosition = videoPlayerController!.value.position;

    Duration position = Duration(); //0초

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition; // 전체길이

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls({
    required this.onPlayPressed,
    required this.onReversPressed,
    required this.onForwardPressed,
    required this.isPlaying,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          rederIconButton(
            onPressed: onReversPressed,
            iconData: Icons.rotate_left,
          ),
          rederIconButton(
            onPressed: onPlayPressed,
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          rederIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }

  Widget rederIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(
        iconData,
      ),
    );
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewVideo({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        color: Colors.white,
        iconSize: 30.0,
        onPressed: onPressed,
        icon: Icon(
          Icons.photo_camera_back,
        ),
      ),
    );
  }
}
