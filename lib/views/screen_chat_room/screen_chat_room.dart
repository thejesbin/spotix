import 'dart:async';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:spotix/core/constants.dart';
import 'package:get/get.dart';
import 'package:spotix/views/screen_send_cash/screen_send_cash.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../core/security.dart';
import '../../models/chat_models.dart';
import '../../services/chat_services.dart';

class ScreenChatRoom extends StatefulWidget {
  final String receiverId;
  final String username;
  final String profile;
  final String verified;
  final String senderId;
  final String senderName;
  final String phone;
  const ScreenChatRoom(
      {super.key,
      required this.receiverId,
      required this.username,
      required this.profile,
      required this.verified,
      required this.senderId,
      required this.senderName,
      required this.phone});

  @override
  State<ScreenChatRoom> createState() => _ScreenChatRoomState();
}

class _ScreenChatRoomState extends State<ScreenChatRoom> {
  var chatList = <ChatModel>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.senderId, widget.receiverId);
    Timer.periodic(Duration(seconds: 1), (timer) {
      getData(widget.senderId, widget.receiverId);
    });
  }

  getData(senderId, receiverId) async {
    var data = await ChatServices().getChats(receiverId, senderId);
    if (data != null) {
      chatList = data;
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  TextEditingController controller = TextEditingController();
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
              backgroundImage: NetworkImage(widget.profile),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.username,
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
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: chatList.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.profile),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Start messaging now...",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Itim"))
                    ],
                  ))
                : GroupedListView<ChatModel, DateTime>(
                    elements: chatList,
                    groupBy: (chats) => DateTime(2023),
                    groupHeaderBuilder: (ChatModel chat) => SizedBox(),
                    indexedItemBuilder: (context, ChatModel chat, i) => Align(
                      alignment: chatList[i].senderId == widget.senderId
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(chatList[i].message.toString()),
                        ),
                      ),
                    ),
                  ),
          ),
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
                                controller: controller,
                              ),
                            ),
                            isTextEmpty.value == 0
                                ? SizedBox()
                                : Row(
                                    children: const [
                                      // Icon(
                                      //   Icons.attach_file,
                                      //   color: Colors.white,
                                      //   size: 18,
                                      // ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      // Icon(
                                      //   Icons.currency_rupee_rounded,
                                      //   color: Colors.white,
                                      //   size: 18,
                                      // ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      // Icon(
                                      //   Icons.photo_camera,
                                      //   color: Colors.white,
                                      //   size: 18,
                                      // ),
                                      // SizedBox(
                                      //   width: 10,
                                      // )
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
                      // return isTextEmpty.value == 0
                      //     ?
                      return InkWell(
                              onTap: () => sendMessage(),
                              child: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 25,
                                child: const Icon(Icons.send),
                              ),
                            );
                          // : InkWell(
                          //     onTap: () => Get.to(() => ScreenSendCash(
                          //         profile: widget.profile,
                          //         phone: widget.phone,
                          //         receiverId: widget.receiverId,
                          //         username: widget.username)),
                          //     child: CircleAvatar(
                          //       backgroundColor: primaryColor,
                          //       radius: 25,
                          //       child: const Text("₹",
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontFamily: "Itim",
                          //             fontSize: 30,
                          //           )),
                          //     ),
                          //   );
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

  sendMessage() async {
   if(controller.text.isEmpty){
      Get.snackbar("Oh no", "Type your message!",
          backgroundColor: Colors.red, colorText: Colors.white);
   }
   else{
     FocusManager.instance.primaryFocus?.unfocus();
    var message = controller.text;
    controller.text = "";
    setState(() {
      chatList.add(ChatModel(
          id: "",
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          message: message));
    });
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "sender_id": encrypt(widget.senderId),
      "receiver_id": encrypt(widget.receiverId),
      "message": encrypt(message)
    });
    var response = await dio.post(sendChatUrl, data: formData);

    // var response = await dio.get(
    //     "https://steycode.in/test/send_chat.php?sender_id=${widget.senderId}&receiver_id=${widget.receiverId}&message=$text");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data['status']);
    }
   }
  }

  Widget callButton(bool isVideoCall) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: [ZegoUIKitUser(id: widget.receiverId, name: widget.username)],
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
