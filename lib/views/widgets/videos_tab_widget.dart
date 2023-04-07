import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

import '../../viewmodels/account_viewmodel.dart';

class VideosTabWidget extends StatelessWidget {
  const VideosTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var account = Get.put(AccountViewmodel());

    return Center(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 170,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(account
                          .accountList[0].videos![i].thumbnail
                          .toString()))),
              child: Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
          );
        },
        itemCount: account.accountList[0].videos!.length,
      ),
    );
  }
}
