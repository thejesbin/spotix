import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/following_viewmodel.dart';
import 'package:spotix/viewmodels/view_user_viewmodel.dart';

import '../../core/security.dart';
import '../widgets/view_user_photos_tab_widget.dart';
import '../widgets/view_user_videos_tab_widget.dart';

class ScreenViewUser extends StatelessWidget {
  final String fid;
  ScreenViewUser({super.key, required this.fid});
  ValueNotifier<String> isFollowing = ValueNotifier("0");
  ValueNotifier<int> followCount = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    var user = Get.put(ViewUserViewmodel(fid: fid));
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var following = Get.put(FollowingViewmodel());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Obx(() => user.isLoading.isTrue
              ? SizedBox(
                  width: 1,
                )
              : Text(
                  user.viewUserList[0].username.toString(),
                  style: const TextStyle(
                    fontFamily: "Itim",
                  ),
                )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            )
          ],
        ),
        body: Obx(() {
          user.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : isFollowing.value = user.viewUserList[0].isFollowing.toString();
          user.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : followCount.value =
                  int.parse(user.viewUserList[0].followers.toString());

          return user.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                user.viewUserList[0].profile.toString()),
                          ),
                          const Spacer(),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                user.viewUserList[0].posts.toString(),
                                style: const TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            // onTap: () =>
                            //     buildFollowersSheet(context, following),
                            child: Column(
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: followCount,
                                    builder: (context, val, child) {
                                      return Text(
                                        followCount.value.toString(),
                                        style: const TextStyle(
                                          fontFamily: "Itim",
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                const Text(
                                  "Followers",
                                  style: TextStyle(
                                    fontFamily: "Itim",
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                user.viewUserList[0].following.toString(),
                                style: const TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.viewUserList[0].name.toString(),
                                style: const TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user.viewUserList[0].bio.toString(),
                                style: const TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: mheight * 0.03,
                      ),
                      ValueListenableBuilder(
                          valueListenable: isFollowing,
                          builder: (context, val, child) {
                            return isFollowing.value == "1"
                                ? InkWell(
                                    onTap: () => followAction(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: mwidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: bgSecondaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Unfollow",
                                        style: TextStyle(
                                          fontFamily: "Itim",
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () => followAction(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: mwidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Follow",
                                        style: TextStyle(
                                          fontFamily: "Itim",
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                      SizedBox(
                        height: mheight * 0.05,
                      ),
                      TabBar(indicatorColor: primaryColor, tabs: [
                        Tab(
                          text: "Photos",
                        ),
                        Tab(
                          text: "Videos",
                        )
                      ]),
                      Expanded(
                        child: TabBarView(children: [
                          user.viewUserList[0].photos == null
                              ? SizedBox(height: 1)
                              : ViewUserPhotosTabWidget(
                                  fid: fid,
                                ),
                          user.viewUserList[0].videos == null
                              ? SizedBox(height: 1)
                              : ViewUserVideosTabWidget(
                                  fid: fid,
                                ),
                        ]),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }

  buildFollowersSheet(BuildContext context, FollowingViewmodel following) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: 400,
              color: bgSecondaryColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) {
                        return SizedBox(
                          height: 65,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(following
                                    .followingList[i].profile
                                    .toString()),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: following.followingList.length,
                    ),
                  ),
                ],
              ));
        });
  }

  followAction() {
    if (isFollowing.value == "1") {
      isFollowing.value = "0";
      followCount.value--;
      updateFollowInServer();
    } else {
      isFollowing.value = "1";
      followCount.value++;

      updateFollowInServer();
    }
  }

  updateFollowInServer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "uid": encrypt(uid!),
      "fid": encrypt(fid),
    });
    dio.post(followUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
  }
}
