import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/viewmodels/view_user_viewmodel.dart';

class ViewUserVideosTabWidget extends StatelessWidget {
  final String fid;
  const ViewUserVideosTabWidget({super.key, required this.fid});

  @override
  Widget build(BuildContext context) {
    var account = Get.put(ViewUserViewmodel(fid: fid));

    return Center(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: 170,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(account
                            .viewUserList[0].videos![i].thumbnail
                            .toString()))),
                child: Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        itemCount: account.viewUserList[0].videos!.length,
      ),
    );
  }
}
