import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spotix/core/constants.dart';

import '../../viewmodels/account_viewmodel.dart';
import '../../viewmodels/chatlist_viewmodel.dart';
import '../screen_chat_room/screen_chat_room.dart';

class ScreenChatList extends StatefulWidget {
  final String uid;
  const ScreenChatList({super.key, required this.uid});

  @override
  State<ScreenChatList> createState() => _ScreenChatListState();
}

class _ScreenChatListState extends State<ScreenChatList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.snackbar("Hey", "Your user id: ${widget.uid}");
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var chats = Get.put(ChatlistViewmodel());
    var account = Get.put(AccountViewmodel());
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage:
                    NetworkImage(account.accountList[0].profile.toString()),
                radius: 13,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                account.accountList[0].username.toString(),
                style: const TextStyle(
                  fontFamily: "Itim",
                  color: Colors.white,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: mwidth * 0.9,
                  child: CupertinoSearchTextField(
                    itemColor: Colors.white,
                    backgroundColor: bgSecondaryColor,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white, fontFamily: "Itim"),
                  ),
                ),
                SizedBox(
                  height: mheight * 0.05,
                ),
                Obx(() => chats.isLoading.isTrue
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () => Get.to(() => ScreenChatRoom(
                                  senderName: account.accountList[0].username
                                      .toString(),
                                  senderId: widget.uid,
                                  receiverId:
                                      chats.chatList[i].receiverId.toString(),
                                  username:
                                      chats.chatList[i].username.toString(),
                                  profile: chats.chatList[i].profile.toString(),
                                  verified:
                                      chats.chatList[i].verified.toString(),
                                  phone: chats.chatList[i].phone.toString(),
                                )),
                            child: SizedBox(
                              height: 55,
                              width: mwidth * 0.95,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        chats.chatList[i].profile.toString()),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chats.chatList[i].username.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Itim"),
                                      ),
                                      Text(
                                        chats.chatList[i].message.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "Itim",
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${chats.chatList[i].date} ${chats.chatList[i].time}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Itim",
                                        fontSize: 9),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: chats.chatList.length,
                      )),
              ],
            ),
          )),
        ));
  }
}
