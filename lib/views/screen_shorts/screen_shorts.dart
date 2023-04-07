import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:video_player/video_player.dart';

import '../../core/security.dart';
import '../../viewmodels/videos_viewmodel.dart';
import '../screen_account/screen_account.dart';
import '../screen_view_user/screen_view_user.dart';

class ScreenShorts extends StatelessWidget {
  const ScreenShorts({super.key});

  @override
  Widget build(BuildContext context) {
    var videosData = Get.put(VideosViewmodel());
    var videos = [video1, video2];
    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(
        () => videosData.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : SizedBox(
                child: Swiper(
                itemCount: videos.length,
                itemBuilder: (context, i) {
                  return VideoScreen(
                    videoUrl: videosData.videosList[i].url.toString(),
                    caption: videosData.videosList[i].caption.toString(),
                    profile: videosData.videosList[i].profile.toString(),
                    likes: videosData.videosList[i].likes.toString(),
                    isLiked: videosData.videosList[i].isLiked.toString(),
                    isVerified: videosData.videosList[i].verified.toString(),
                    pid: videosData.videosList[i].pid.toString(),
                    username: videosData.videosList[i].username.toString(),
                    id: videosData.videosList[i].uid.toString(),
                  );
                },
                scrollDirection: Axis.vertical,
              )),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final String profile;
  final String username;
  final String pid;
  final String isVerified;
  final String likes;
  final String isLiked;
  final String caption;
  final String id;
  const VideoScreen(
      {super.key,
      required this.videoUrl,
      required this.profile,
      required this.username,
      required this.pid,
      required this.isVerified,
      required this.likes,
      required this.isLiked,
      required this.caption,
      required this.id});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(playedColor: primaryColor),
    );
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  ValueNotifier<int> likeCount = ValueNotifier(0);
  ValueNotifier<String> liked = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    likeCount.value = int.parse(widget.likes);
    liked.value = widget.isLiked;
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      _chewieController!.pause();
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      var uid = sharedPreferences.getString("uid");
                      if (uid == widget.id) {
                        Get.to(ScreenAccount());
                      } else {
                        Get.to(ScreenViewUser(
                          fid: widget.id,
                        ));
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(widget.profile),
                      radius: 22,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: liked,
                      builder: (context, val, child) {
                        return liked.value == "1"
                            ? InkWell(
                                onTap: () => likePhoto(),
                                child: Icon(
                                  HeroIcons.heart,
                                  size: 30,
                                  color: primaryColor,
                                ),
                              )
                            : InkWell(
                                onTap: () => likePhoto(),
                                child: const Icon(
                                  Icons.favorite_outline,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              );
                      }),
                  ValueListenableBuilder(
                      valueListenable: likeCount,
                      builder: (context, val, child) {
                        return Text(
                          likeCount.value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Itim",
                              fontSize: 12),
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          _chewieController!.pause();
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var uid = sharedPreferences.getString("uid");
                          if (uid == widget.id) {
                            Get.to(ScreenAccount());
                          } else {
                            Get.to(ScreenViewUser(
                              fid: widget.id,
                            ));
                          }
                        },
                        child: Text(
                          "@ ${widget.username}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Itim",
                              fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      widget.isVerified == "yes"
                          ? Image.asset(
                              "assets/verified.png",
                              height: 15,
                            )
                          : const SizedBox(
                              width: 1,
                            )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          widget.caption,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
        )
      ],
    );
  }

  likePhoto() {
    if (liked.value == "1") {
      liked.value = "0";
      likeCount.value--;
      updateLikeInServer();
    } else {
      liked.value = "1";
      likeCount.value++;
      updateLikeInServer();
    }
  }

  updateLikeInServer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "uid": encrypt(uid!),
      "pid": encrypt(widget.pid),
    });
    dio.post(likeUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
  }
}
