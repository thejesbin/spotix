// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/security.dart';
import '../../core/constants.dart';
import '../screen_comments/screen_comments.dart';
import '../screen_view_user/screen_view_user.dart';
import '../screen_account/screen_account.dart';
import '../screen_main/screen_main.dart';
class PhotosWidget extends StatelessWidget {
  final String id;
  final String pid;
  final String profileUrl;
  final String username;
  final String postUrl;
  final String isLiked;
  final String likes;
  final String verified;
  final String caption;
  PhotosWidget(
      {super.key,
      required this.pid,
      required this.profileUrl,
      required this.username,
      required this.postUrl,
      required this.isLiked,
      required this.likes,
      required this.verified,
      required this.caption,
      required this.id});
  ValueNotifier<int> likeCount = ValueNotifier(0);
  ValueNotifier<String> liked = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    likeCount.value = int.parse(likes);
    liked.value = isLiked;
    return SizedBox(
      height: 600,
      width: mwidth,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () async {
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
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(profileUrl),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 2,
                    child: verified == "yes"
                        ? Image.asset(
                            "assets/verified.png",
                            height: 20,
                          )
                        : const SizedBox(
                            height: 1,
                          ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
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
                child: Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Itim",
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () => showOptions(context),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ReadMoreText(
                  caption,
                  trimLines: 1,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " ",
                  trimExpandedText: "Show less",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Itim",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onDoubleTap: () => likePhoto(),
            child: InteractiveViewer(
              child: Container(
                height: 450,
                width: mwidth * 0.99,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(postUrl), fit: BoxFit.cover)),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          ValueListenableBuilder(
              valueListenable: liked,
              builder: (context, val, child) {
                return Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    liked.value == "1"
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
                          ),
                    const SizedBox(
                      width: 25,
                    ),
                    InkWell(
                      onTap: () => Get.to(() => ScreenComments(
                            pid: pid,
                          )),
                      child: const Icon(
                        Bootstrap.chat,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    const Icon(
                      Bootstrap.send,
                      size: 25,
                      color: Colors.white,
                    )
                  ],
                );
              }),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              ValueListenableBuilder(
                  valueListenable: likeCount,
                  builder: (context, val, child) {
                    return Text(
                      "${likeCount.value} Likes",
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Itim",
                          fontSize: 11),
                    );
                  })
            ],
          )
        ],
      ),
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
      "pid": encrypt(pid),
    });
    dio.post(likeUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
  }

  showOptions(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var myUid = sharedPreferences.getString("uid");
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
              myUid!=id?SizedBox(height: 1,):  InkWell(
                  onTap: ()=>deletePost(myUid,context),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Delete",
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
                  onTap: ()=>reportPost(myUid,context),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.report,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Report",
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
  
  deletePost(myuid, BuildContext context) async {
    Get.snackbar(
      "Please Wait",
      'Deleting post...',
      icon: Row(
        children: const [
          SizedBox(
            width: 5,
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap(
        {'api': encrypt(apiKey), 'uid': encrypt(myuid), 'pid': encrypt(pid)});
    var response = await dio.post(deletePostUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['status'] == true) {
        Get.snackbar(
          "Yay yay",
          response.data['msg'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return ScreenMain();
        }), (route) => false);
      } else {
        Get.snackbar(
          "Oh no",
          response.data['msg'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return ScreenMain();
        }), (route) => false);
      }
    } else {
      Get.snackbar(
        "Oh no",
        "Some error occurred",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return ScreenMain();
      }), (route) => false);
    }
  }

  reportPost(myuid, BuildContext context) async {
    Get.snackbar(
      "Please Wait",
      'Reporting post...',
      icon: Row(
        children: const [
          SizedBox(
            width: 5,
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap(
        {'api': encrypt(apiKey), 'uid': encrypt(myuid), 'pid': encrypt(pid)});
    var response = await dio.post(reportPostUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['status'] == true) {
        Get.snackbar(
          "Yay yay",
          response.data['msg'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return ScreenMain();
        }), (route) => false);
      } else {
        Get.snackbar(
          "Oh no",
          response.data['msg'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return ScreenMain();
        }), (route) => false);
      }
    } else {
      Get.snackbar(
        "Oh no",
        "Some error occurred",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return ScreenMain();
      }), (route) => false);
    }
  }

}
