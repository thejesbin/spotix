import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants.dart';
import '../../viewmodels/channels_viewmodel.dart';

class ScreenTvPlayer extends StatefulWidget {
  final String url;
  final String name;
  final String logo;
  final String language;
  const ScreenTvPlayer(
      {super.key,
      required this.url,
      required this.name,
      required this.logo,
      required this.language});

  @override
  State<ScreenTvPlayer> createState() => _ScreenTvPlayerState();
}

class _ScreenTvPlayerState extends State<ScreenTvPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.url);
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
    var channels = Get.put(ChannelsViewmodel());
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: 250,
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Loading...',
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Itim"),
                        )
                      ],
                    ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Now Playing",
                  style: TextStyle(color: Colors.grey, fontFamily: "Itim"),
                )
              ],
            ),
            Row(children: [
              SizedBox(
                width: 10,
              ),
              Container(
                height: 60,
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain, image: NetworkImage(widget.logo))),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.name,
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: "Itim"),
              ),
              Spacer(),
              Text(
                "language: ${widget.language}",
                style: TextStyle(color: Colors.grey, fontFamily: "Itim"),
              ),
              SizedBox(
                width: 10,
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Suggested Channels",
                  style: TextStyle(color: Colors.grey, fontFamily: "Itim"),
                )
              ],
            ),
            Obx(
              () => channels.isLoading.isTrue
                  ? LinearProgressIndicator(
                      color: Colors.white,
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, i) {
                          var data = channels.channelsList[i];
                          return InkWell(
                            onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ScreenTvPlayer(
                                    url: data.url.toString(),
                                    name: data.name.toString(),
                                    logo: data.logo.toString(),
                                    language: data.language.toString()),
                              ),
                            ),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Row(children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              data.logo.toString()))),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: "Itim"),
                                )
                              ]),
                            ),
                          );
                        },
                        itemCount: channels.channelsList.length,
                      ),
                    ),
            )
          ],
        )),
      ),
    );
  }
}
