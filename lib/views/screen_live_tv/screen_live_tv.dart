import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

import '../../viewmodels/channels_viewmodel.dart';
import '../screen_tv_player/screen_tv_player.dart';

class ScreenLiveTv extends StatelessWidget {
  const ScreenLiveTv({super.key});

  @override
  Widget build(BuildContext context) {
    var channels = Get.put(ChannelsViewmodel());
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Obx(
          () => channels.isLoading.isTrue
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoSearchTextField(
                      onChanged: (String text) {},
                      itemColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Itim",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, i) {
                        var data = channels.channelsList[i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => Get.to(() => ScreenTvPlayer(
                                url: data.url.toString(),
                                name: data.name.toString(),
                                logo: data.logo.toString(),
                                language: data.language.toString())),
                            child: Container(
                              height: 150,
                              width: 150,
                              alignment: Alignment.center,
                              child: Column(children: [
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: NetworkImage(
                                              data.logo.toString()))),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  data.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: "Itim"),
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                      itemCount: channels.channelsList.length,
                    ),
                  )
                ]),
        ),
      ),
    );
  }
}
