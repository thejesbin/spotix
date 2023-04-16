import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/comments_model.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';
import 'package:spotix/viewmodels/comments_viewmodel.dart';

import '../../core/constants.dart';

class ScreenComments extends StatelessWidget {
  final String pid;
  ScreenComments({super.key, required this.pid});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var comments = Get.put(CommentsViewmodel(pid: pid));
    var user = Get.put(AccountViewmodel());
    var mwidth = MediaQuery.of(context).size.width;
    var mheight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text(
            "Comments",
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
        body: Center(
          child: Obx(
            () => comments.isLoading.isTrue
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Column(
                    children: [
                      comments.isEmpty.isTrue
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "No Comments",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, i) {
                                  var data = comments.commentsList[i];
                                  return Container(
                                    height: 70,
                                    width: mwidth * 0.95,
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          radius: 13,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              data.profile.toString()),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  data.username.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Itim"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              data.comment.toString(),
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: comments.commentsList.length,
                              ),
                            ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextField(
                            controller: controller,
                            maxLines: 5,
                            minLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Itim",
                                fontSize: 13),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Something",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Itim",
                                    fontSize: 13)),
                          )),
                          IconButton(
                              onPressed: () => postComment(comments, user),
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
          ),
        ));
  }

  postComment(CommentsViewmodel comments, AccountViewmodel user) async {
    var comment = controller.text;
    if (comment.isEmpty) {
      Get.snackbar("Oh no", "Type your comment!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      comment="";
      comments.isLoading.value=true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString("uid");
      d.Dio dio = d.Dio();
      var formData = d.FormData.fromMap({
        "api": encrypt(apiKey),
        "pid": encrypt(pid),
        "uid": encrypt(uid!),
        "comment": encrypt(comment)
      });
      var response = await dio.post(postcommentUrl,data: formData,options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
      if(response.statusCode==200||response.statusCode==201){
        print("hello");
        comments.getData(pid);
        
      }
      else{
        print("No response");
      }
    }
  }
}
