import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

import '../../viewmodels/notificatons_viewmodel.dart';
import '../screen_view_user/screen_view_user.dart';

class ScreenNotifications extends StatelessWidget {
  const ScreenNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    var notifications = Get.put(NotificationsViewmodel());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Notifications",
          style: TextStyle(fontFamily: "Itim"),
        ),
      ),
      body: Center(
        child: Obx(() => notifications.isLoading.isTrue
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : ListView.builder(
                itemBuilder: (context, i) {
                  var data = notifications.notificationsList[i];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Get.to(() => ScreenViewUser(
                            fid: data.fid.toString(),
                          )),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(data.profile.toString()),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Itim",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${data.time} ${data.date}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Itim",
                                  fontSize: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  );
                },
                itemCount: notifications.notificationsList.length,
              )),
      ),
    );
  }
}
