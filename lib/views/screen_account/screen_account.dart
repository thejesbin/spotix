import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';

import '../../core/security.dart';
import '../screen_edit_profile/screen_edit_profile.dart';
import '../widgets/photos_tab_widget.dart';
import '../widgets/videos_tab_widget.dart';

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({super.key});
  pickImage(context) async {
    Navigator.pop(context);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      if (image == null) return;
      final imageTemporary = File(image.path);
      updateDp(imageTemporary);
      // Get.to(() => ScreenUploadPhoto(image: imageTemporary));
    } on PlatformException catch (e) {
      print("failed to pick image :$e");
    }
  }

  updateDp(File image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString('uid');
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
              "Updating your profile photo!",
              style: TextStyle(color: Colors.white, fontFamily: "Itim"),
            )
          ],
        ),
        duration: Duration(seconds: 10));
    d.Dio dio = d.Dio();
    var formdata = d.FormData.fromMap(
      {
        "image": await d.MultipartFile.fromFile(image.path),
        "uid": encrypt(uid!),
        "api": encrypt(apiKey)
      },
    );
    final response = await dio.post(
      updateDpUrl,
      data: formdata,
      options: d.Options(contentType: d.Headers.formUrlEncodedContentType),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.closeAllSnackbars();
      if (response.data['status'] == true) {
        Get.snackbar("Hey Hey", response.data['msg'],
            backgroundColor: Colors.green, colorText: Colors.white);
        var user = Get.put(AccountViewmodel());
        user.getData();
      } else {
        Get.snackbar("Oh no", response.data['msg'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.closeAllSnackbars();
    }
  }

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
                            InkWell(
                              onTap: () => pickImage(context),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    user.accountList[0].profile.toString()),
                              ),
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
                        InkWell(
                          onTap: () => Get.to(()=>ScreenEditProfile()),
                          child: Container(
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
