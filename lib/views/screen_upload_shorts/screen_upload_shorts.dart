import 'dart:io';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:better_player/better_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../core/security.dart';
import '../screen_main/screen_main.dart';

class ScreenUploadShorts extends StatefulWidget {
  final File video;
  const ScreenUploadShorts({super.key, required this.video});

  @override
  State<ScreenUploadShorts> createState() => _ScreenUploadShortsState();
}

class _ScreenUploadShortsState extends State<ScreenUploadShorts> {
  //late VideoPlayerController _videoPlayerController;
   late BetterPlayerController betterPlayerController;
  TextEditingController captionController = TextEditingController();
  ValueNotifier<int> isUploading = ValueNotifier(0);
  ValueNotifier<int> uploadingPercentage = ValueNotifier(0);
 // ChewieController? _chewieController;
  //late var videoThumbnail;
  @override
  void initState() {
    super.initState();
    initializePlayer();
    // getThumbNail();
  }

  // getThumbNail() async {
  //   videoThumbnail = await VideoThumbnail.thumbnailData(
  //     video: widget.video.path,
  //     imageFormat: ImageFormat.JPEG,
  //     quality: 80,
  //   );
  // }

  Future initializePlayer() async {
    // _videoPlayerController = VideoPlayerController.file(widget.video);
    // await Future.wait([_videoPlayerController.initialize()]);
    // _chewieController = ChewieController(
    //     videoPlayerController: _videoPlayerController,
    //     autoPlay: true,
    //     showControls: true,
    //     materialProgressColors: ChewieProgressColors(
    //         playedColor: primaryColor, backgroundColor: Colors.white));
    // setState(() {});
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.video.path);
    betterPlayerController = BetterPlayerController(
         BetterPlayerConfiguration(
           
            autoPlay: true,
            aspectRatio: 9 / 16,
            fit: BoxFit.contain,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              enableFullscreen: false,
              enableSkips: true,
              enableRetry: false,
            )),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   _chewieController!.dispose();
  //   super.dispose();
  // }

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
                   BetterPlayer(controller: betterPlayerController),
                  // _chewieController != null &&
                  //         _chewieController!
                  //             .videoPlayerController.value.isInitialized
                  //     ? Chewie(
                  //         controller: _chewieController!,
                  //       )
                  //     : Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: const [
                  //           CircularProgressIndicator(),
                  //           SizedBox(height: 10),
                  //           Text('Loading...')
                  //         ],
                  //       ),

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
                  width: 10,
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

  uploadVideo() async {
    var caption = captionController.text;
    if (caption.isEmpty) {
      Get.snackbar("Oh No!", "Enter a caption",
          colorText: Colors.white, backgroundColor: Colors.red);
    } else if (caption.length > 80) {
      Get.snackbar("Oh No!", "Maximum length is 80 characters",
          colorText: Colors.white, backgroundColor: Colors.red);
    } else {
      isUploading.value = 1;
      final videoThumbnail = await VideoThumbnail.thumbnailData(
        video: widget.video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 80,
      );
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString('uid');
      captionController.text = "";
      FocusManager.instance.primaryFocus?.unfocus();
      Get.snackbar("", "",
          colorText: Colors.white,
          backgroundColor: bgColor,
          titleText: LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: primaryColor,
          ),
          messageText: Row(
            children: const [
              Text(
                "Uploading shorts....",
                style: TextStyle(color: Colors.white, fontFamily: "Itim"),
              )
            ],
          ),
          duration: Duration(minutes: 5));
      d.Dio dio = d.Dio();
      var formdata = d.FormData.fromMap(
        {
          "video": await d.MultipartFile.fromFile(widget.video.path),
          "thumb": d.MultipartFile.fromBytes(videoThumbnail!),
          "uid": encrypt(uid!),
          "caption": encrypt(caption),
          "api": encrypt(apiKey)
        },
      );
      final response = await dio.post(
        uploadVideoUrl,
        data: formdata,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isUploading.value = 0;
        Get.closeAllSnackbars();
        if (response.data['status'] == true) {
          Get.snackbar("Hey Hey", response.data['msg'],
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAll(() => const ScreenMain());
        } else {
          Get.snackbar("Oh no", response.data['msg'],
              backgroundColor: Colors.red, colorText: Colors.white);
          Get.offAll(() => const ScreenMain());
        }
      } else {
         Get.closeAllSnackbars();
        isUploading.value = 0;
      }
    }
  }
}
