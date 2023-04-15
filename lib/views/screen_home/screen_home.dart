import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/history_viewmodel.dart';
import 'package:spotix/views/screen_account/screen_account.dart';
import 'package:spotix/views/screen_chat_list/screen_chat_list.dart';
import 'package:video_player/video_player.dart';
import '../../viewmodels/account_viewmodel.dart';
import '../../viewmodels/photos_viewmodel.dart';
import '../../viewmodels/videos_viewmodel.dart';
import '../screen_notifications/screen_notifications.dart';
import '../screen_upload_photo/screen_upload_photo.dart';
import '../screen_upload_shorts/screen_upload_shorts.dart';
import '../widgets/photos_widget.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});
  pickImage(context) async {
    Navigator.pop(context);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      if (image == null) return;
      final imageTemporary = File(image.path);
      Get.to(() => ScreenUploadPhoto(image: imageTemporary));
    } on PlatformException catch (e) {
      print("failed to pick image :$e");
    }
  }

  pickVideo(context) async {
    try {
      Navigator.pop(context);
      final video = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      if (video == null) return;
      VideoPlayerController testLength =
          VideoPlayerController.file(File(video.path));
      await testLength.initialize();
      if (testLength.value.duration.inSeconds > 120) {
        Get.snackbar(
          "Ho no",
          "Maximum video length is 120s",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } else {
        final videoTemporary = File(video.path);
        Get.to(() => ScreenUploadShorts(video: videoTemporary));
      }
    } on PlatformException catch (e) {
      print("failed to pick video :$e");
    }
  }

  buildBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: bgSecondaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => pickImage(context),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        HeroIcons.photo,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Photos",
                        style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => pickVideo(context),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.subscriptions,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Shorts",
                        style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var photos = Get.put(PhotosViewmodel());
    var account = Get.put(AccountViewmodel());
    var videos = Get.put(VideosViewmodel());
    var history = Get.put(HistoryViewmodel());

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text(
            appName,
            style: TextStyle(fontFamily: "Itim", fontSize: 25),
          ),
          backgroundColor: bgColor,
          actions: [
            IconButton(
                onPressed: () => buildBottomSheet(context),
                icon: const Icon(HeroIcons.squares_plus)),
            IconButton(
                onPressed: () => Get.to(() => ScreenNotifications()),
                icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  var uid = sharedPreferences.getString("uid");
                  Get.to(() => ScreenChatList(
                        uid: uid!,
                      ));
                },
                icon: const Icon(Icons.chat_bubble)),
            Obx(
              () => account.isLoading.isTrue
                  ? SizedBox(
                      height: 1,
                    )
                  : InkWell(
                      onTap: () => Get.to(() => ScreenAccount()),
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    account.accountList[0].profile.toString()),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            photos.getData();
            account.getData();
            videos.getData();
            history.getData();
          },
          child: Obx(() => photos.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, i) {
                    var data = photos.photosList[i];
                    return i == 1
                        ? Container(
                            height: 180,
                            width: mwidth,
                            color: Colors.transparent,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () => buildPhotoSheet(
                                      context,
                                      mwidth,
                                      photos.photosList[i].id.toString(),
                                      photos.photosList[i].pid.toString(),
                                      photos.photosList[i].profile.toString(),
                                      photos.photosList[i].username.toString(),
                                      photos.photosList[i].url.toString(),
                                      photos.photosList[i].isLiked.toString(),
                                      photos.photosList[i].likes.toString(),
                                      photos.photosList[i].verified.toString(),
                                      photos.photosList[i].caption.toString(),
                                    ),
                                    child: Container(
                                      height: 150,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(photos
                                                  .photosList[i].url
                                                  .toString()),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                );
                              },
                              itemCount: photos.photosList.length,
                            ),
                          )
                        : PhotosWidget(
                            id: data.id.toString(),
                            pid: data.pid.toString(),
                            profileUrl: data.profile.toString(),
                            username: data.username.toString(),
                            postUrl: data.url.toString(),
                            isLiked: data.isLiked.toString(),
                            likes: data.likes.toString(),
                            verified: data.verified.toString(),
                            caption: data.caption.toString(),
                          );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: photos.photosList.length)),
        ));
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
