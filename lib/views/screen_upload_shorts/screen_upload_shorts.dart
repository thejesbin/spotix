import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:spotix/core/constants.dart';
import 'package:video_player/video_player.dart';

class ScreenUploadShorts extends StatefulWidget {
  final File video;
  const ScreenUploadShorts({super.key, required this.video});

  @override
  State<ScreenUploadShorts> createState() => _ScreenUploadShortsState();
}

class _ScreenUploadShortsState extends State<ScreenUploadShorts> {
  late VideoPlayerController _videoPlayerController;
  TextEditingController captionController = TextEditingController();
  ValueNotifier<int> isUploading = ValueNotifier(0);
  ValueNotifier<int> uploadingPercentage = ValueNotifier(0);
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.video);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
            playedColor: primaryColor, backgroundColor: Colors.white));
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Create Post",
          style: TextStyle(fontFamily: 'Mukta'),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(
                          controller: _chewieController!,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Loading...')
                          ],
                        ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                  controller: captionController,
                  maxLines: 5,
                  minLines: 1,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: "Itim", fontSize: 13),
                  decoration: InputDecoration(
                      fillColor: bgSecondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: "Enter Something",
                      hintStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Itim",
                          fontSize: 13)),
                )),
                const SizedBox(
                  width: 10,
                ),
                ValueListenableBuilder(
                    valueListenable: isUploading,
                    builder: (context, val, child) {
                      return isUploading.value == 1
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : IconButton(
                              onPressed: () => uploadVideo(),
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ));
                    }),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        )),
      ),
    );
  }

  uploadVideo() {}
}
