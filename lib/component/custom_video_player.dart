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
          ),
          Positioned(
            right: 0,
            child: IconButton(
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {},
              icon: Icon(
                Icons.photo_camera_back,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPlayPressed(){
    // 1.이미 실행중이면 중지
    // 2.실행중이 아니면 실행
    if(videoPlayerController!.value.isPlaying){
      videoPlayerController!.pause();
    }else{
      videoPlayerController!.play();
    }
  }
  void onReversPressed(){}
  void onForwardPressed(){}

}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversPressed;
  final VoidCallback onForwardPressed;

  const _Controls({
    required this.onPlayPressed,
    required this.onReversPressed,
    required this.onForwardPressed,
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
            iconData: Icons.play_arrow,
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
        Icons.play_arrow,
      ),
    );
  }
}
