import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotix/core/constants.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../screen_videocall/screen_videocall.dart';

class ScreenChatRoom extends StatelessWidget {
  final String receiverId;
  final String username;
  final String profile;
  final String verified;
  final String senderId;
  final String senderName;
  const ScreenChatRoom(
      {super.key,
      required this.receiverId,
      required this.username,
      required this.profile,
      required this.verified,
      required this.senderId,
      required this.senderName});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> isTextEmpty = ValueNotifier(1);
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(profile),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Itim",
                fontSize: 14,
              ),
            )
          ],
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //      // Get.to(() => CallInvitationPage());
          //     },
          //     icon: const Icon(Icons.videocam)),
          //IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          Row(
            children: [
              callButton(false),
              callButton(true),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            alignment: Alignment.center,
            width: mwidth * 0.98,
            height: 70,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 60,
                  width: mwidth * 0.75,
                  decoration: BoxDecoration(
                    color: bgSecondaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: isTextEmpty,
                      builder: (context, val, child) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 10,
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    isTextEmpty.value = 0;
                                  } else {
                                    isTextEmpty.value = 1;
                                  }
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            isTextEmpty.value == 0
                                ? SizedBox()
                                : Row(
                                    children: const [
                                      Icon(
                                        Icons.attach_file,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.currency_rupee_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.photo_camera,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  )
                          ],
                        );
                      }),
                ),
                const Spacer(),
                ValueListenableBuilder(
                    valueListenable: isTextEmpty,
                    builder: (context, val, child) {
                      return isTextEmpty.value == 0
                          ? InkWell(
                              onTap: () => Get.to(() => CallPage()),
                              child: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 25,
                                child: const Icon(Icons.send),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 25,
                              child: const Icon(Icons.mic),
                            );
                    }),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget callButton(bool isVideoCall) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: [ZegoUIKitUser(id: receiverId, name: username)],
      resourceID: "zegouikit_call",
      iconSize: const Size(40, 40),
      buttonSize: const Size(50, 50),
    );
  }
}
  // void onSendCallInvitationFinished(
  //   String code,
  //   String message,
  //   List<String> errorInvitees,
  // ) {
  //   if (errorInvitees.isNotEmpty) {
  //     String userIDs = "";
  //     for (int index = 0; index < errorInvitees.length; index++) {
  //       if (index >= 5) {
  //         userIDs += '... ';
  //         break;
  //       }

  //       var userID = errorInvitees.elementAt(index);
  //       userIDs += userID + ' ';
  //     }
  //     if (userIDs.isNotEmpty) {
  //       userIDs = userIDs.substring(0, userIDs.length - 1);
  //     }

  //     var message = '${username} is offline';
  //     if (code.isNotEmpty) {
  //       message += ', code: $code, message:$message';
  //     }
  //     showToast(
  //       message,
  //       position: StyledToastPosition.top,
  //       context: context,
  //     );
  //   } else if (code.isNotEmpty) {
  //     showToast(
  //       'code: $code, message:$message',
  //       position: StyledToastPosition.top,
  //       context: context,
  //     );
  //   }
  // }

  // List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  //   List<ZegoUIKitUser> invitees = [];

  //   var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  //   inviteeIDs.split(",").forEach((inviteeUserID) {
  //     if (inviteeUserID.isEmpty) {
  //       return;
  //     }

  //     invitees.add(ZegoUIKitUser(
  //       id: inviteeUserID,
  //       name: 'user_$inviteeUserID',
  //     ));
  //   });

  //   return invitees;
  // }
