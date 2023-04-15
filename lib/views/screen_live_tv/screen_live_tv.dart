import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';

import '../../viewmodels/channels_viewmodel.dart';
import '../../viewmodels/search_channels_viewmodel.dart';
import '../screen_tv_player/screen_tv_player.dart';

class ScreenLiveTv extends StatelessWidget {
  const ScreenLiveTv({super.key});

  @override
  Widget build(BuildContext context) {
    var channels = Get.put(ChannelsViewmodel());
    var searchData = Get.put(SearchChannelsViewmodel());
    ValueNotifier<int> isSearching = ValueNotifier(0);
    TextEditingController controller = TextEditingController();
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
                      controller: controller,
                      onSuffixTap: () {
                        isSearching.value = 0;
                        controller.text = "";
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (String text) {
                        if (text.isEmpty) {
                          isSearching.value = 0;
                        }
                        {
                          isSearching.value = 1;
                          searchData.getData(text);
                        }
                      },
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
                  ValueListenableBuilder(
                      valueListenable: isSearching,
                      builder: (context, val, child) {
                        return isSearching.value == 1
                            ? Obx(
                                () => searchData.isLoading.isTrue
                                    ? CircularProgressIndicator()
                                    : searchData.searchChannelsList.isEmpty
                                        ? Text(
                                            "No channels found",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : buildSearchResult(
                                            context, searchData),
                              )
                            : Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (context, i) {
                                    var data = channels.channelsList[i];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () => Get.to(() =>
                                            ScreenTvPlayer(
                                                url: data.url.toString(),
                                                name: data.name.toString(),
                                                logo: data.logo.toString(),
                                                language:
                                                    data.language.toString())),
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
                                                      image: NetworkImage(data
                                                          .logo
                                                          .toString()))),
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
                              );
                      })
                ]),
        ),
      ),
    );
  }

  Widget buildSearchResult(
      BuildContext context, SearchChannelsViewmodel searchData) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              var id = searchData.searchChannelsList[i].id.toString();
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var uid = sharedPreferences.getString("uid");
              Get.to(() => ScreenTvPlayer(
                  url: searchData.searchChannelsList[i].url.toString(),
                  name: searchData.searchChannelsList[i].name.toString(),
                  logo: searchData.searchChannelsList[i].logo.toString(),
                  language:
                      searchData.searchChannelsList[i].language.toString()));
            },
            child: Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        searchData.searchChannelsList[i].logo.toString()),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    searchData.searchChannelsList[i].name.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Itim",
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: searchData.searchChannelsList.length,
    ));
  }
}
