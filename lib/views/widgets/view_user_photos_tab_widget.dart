import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';
import 'package:spotix/views/widgets/photos_widget.dart';

import '../../core/constants.dart';
import '../../viewmodels/view_user_viewmodel.dart';

class ViewUserPhotosTabWidget extends StatelessWidget {
 final String fid;
  const ViewUserPhotosTabWidget({super.key, required this.fid});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var account = Get.put(ViewUserViewmodel(fid: fid));
    return Center(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () => buildPhotoSheet(
                  context,
                  mwidth,
                  account.viewUserList[0].photos![i].id.toString(),
                  account.viewUserList[0].photos![i].pid.toString(),
                  account.viewUserList[0].photos![i].profile.toString(),
                  account.viewUserList[0].username.toString(),
                  account.viewUserList[0].photos![i].url.toString(),
                  account.viewUserList[0].photos![i].isLiked.toString(),
                  account.viewUserList[0].photos![i].likes.toString(),
                  account.viewUserList[0].photos![i].verified.toString(),
                  account.viewUserList[0].photos![i].caption.toString()),
              child: Container(
                height: 170,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            account.viewUserList[0].photos![i].url.toString()))),
              ),
            ),
          );
        },
        itemCount: account.viewUserList[0].photos!.length,
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
