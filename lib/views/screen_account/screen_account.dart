import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';

import '../widgets/photos_tab_widget.dart';
import '../widgets/videos_tab_widget.dart';

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Get.put(AccountViewmodel());
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Obx(() => DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: bgColor,
              title: Text(
                user.accountList[0].username.toString(),
                style: const TextStyle(
                  fontFamily: "Itim",
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                )
              ],
            ),
            body: Center(
              child: user.isLoading.isTrue
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Column(
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
                                  user.accountList[0].profile.toString()),
                            ),
                            const Spacer(),
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  user.accountList[0].posts.toString(),
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
                            Column(
                              children: [
                                Text(
                                  user.accountList[0].followers.toString(),
                                  style: const TextStyle(
                                    fontFamily: "Itim",
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
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
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  user.accountList[0].following.toString(),
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
                                  user.accountList[0].name.toString(),
                                  style: const TextStyle(
                                    fontFamily: "Itim",
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  user.accountList[0].bio.toString(),
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
                        Container(
                          alignment: Alignment.center,
                          height: 35,
                          width: mwidth * 0.8,
                          decoration: BoxDecoration(
                            color: bgSecondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontFamily: "Itim",
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                          child: Container(
                            child: TabBarView(children: [
                              user.accountList[0].photos == null
                                  ? SizedBox(height: 1)
                                  : PhotosTabWidget(),
                              user.accountList[0].videos == null
                                  ? SizedBox(height: 1)
                                  : VideosTabWidget()
                            ]),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ));
  }
}
