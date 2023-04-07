// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/photos_viewmodel.dart';

import '../../viewmodels/search_viewmodel.dart';
import '../screen_account/screen_account.dart';
import '../screen_view_user/screen_view_user.dart';
import '../widgets/photos_widget.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    var photos = Get.put(PhotosViewmodel());
    var searchData = Get.put(SearchViewmodel());
    ValueNotifier<int> isSearching = ValueNotifier(0);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder(
              valueListenable: isSearching,
              builder: (context, val, child) {
                return Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CupertinoSearchTextField(
                      onChanged: (String text) {
                        if (text.length > 0) {
                          isSearching.value = 0;
                        }
                        {
                          isSearching.value = 1;
                          searchData.getData(text);
                        }
                      },
                      itemColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Itim",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isSearching.value == 1
                      ? Obx(() => searchData.isLoading.isTrue
                          ? Expanded(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : searchData.searchList.isEmpty
                              ? Text(
                                  "No Data",
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: "Itim"),
                                )
                              : buildSearchResult(context, searchData))
                      : Obx(() => photos.isLoading.isTrue
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : buildSearchPhotos(context, photos))
                ]);
              }),
        ),
      ),
    );
  }

  Widget buildSearchResult(BuildContext context, SearchViewmodel searchData) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              var id = searchData.searchList[i].id.toString();
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var uid = sharedPreferences.getString("uid");
              if (uid == id) {
                Get.to(ScreenAccount());
              } else {
                Get.to(ScreenViewUser(
                  fid: id,
                ));
              }
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
                        searchData.searchList[i].profile.toString()),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    searchData.searchList[i].username.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Itim",
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  searchData.searchList[i].verified == "yes"
                      ? Image.asset("assets/verified.png", height: 15)
                      : SizedBox(width: 1),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: searchData.searchList.length,
    ));
  }

  Widget buildSearchPhotos(BuildContext context, PhotosViewmodel photos) {
    return Expanded(
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => buildPhotoSheet(
                  context,
                  MediaQuery.of(context).size.width,
                  photos.photosList[i].id.toString(),
                  photos.photosList[i].pid.toString(),
                  photos.photosList[i].profile.toString(),
                  photos.photosList[i].username.toString(),
                  photos.photosList[i].url.toString(),
                  photos.photosList[i].isLiked.toString(),
                  photos.photosList[i].likes.toString(),
                  photos.photosList[i].verified.toString(),
                  photos.photosList[i].caption.toString()),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      photos.photosList[i].url.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: photos.photosList.length,
      ),
    );
  }

  buildPhotoSheet(
    BuildContext context,
    mwidth,
    String id,
    String pid,
    String profileUrl,
    String username,
    String postUrl,
    String isLiked,
    String likes,
    String verified,
    String caption,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(2),
            backgroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bgColor,
              ),
              width: 350,
              child: PhotosWidget(
                  id: id,
                  pid: pid,
                  profileUrl: profileUrl,
                  username: username,
                  postUrl: postUrl,
                  isLiked: isLiked,
                  likes: likes,
                  verified: verified,
                  caption: caption),
            ),
          );
        });
  }
}
