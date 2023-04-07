import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';
import 'package:spotix/views/screen_splash/screen_splash.dart';

import '../../viewmodels/following_viewmodel.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../screen_add_cash/screen_add_cash.dart';
import '../screen_send_cash/screen_send_cash.dart';

class ScreenWallet extends StatelessWidget {
  const ScreenWallet({super.key});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var user = Get.put(AccountViewmodel());
    var following = Get.put(FollowingViewmodel());
    var history = Get.put(HistoryViewmodel());
    var dt = DateTime.now();
    var greeting;
    if (dt.hour < 12) {
      greeting = "Good morning";
    } else if (dt.hour >= 12) {
      greeting = "Good afternoon";
    } else if (dt.hour >= 15) {
      greeting = "Good evening";
    } else if (dt.hour >= 19) {
      greeting = "Good night";
    }
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Obx(
          () => user.isLoading.isTrue
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: mheight * 0.4,
                      width: mwidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 31, 94, 87),
                              Color.fromARGB(255, 42, 112, 102),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: mheight * 0.07,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();
                                  Get.offAll(() => ScreenSplash());
                                },
                                child: Icon(
                                  Icons.drag_handle_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    greeting,
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontFamily: "Itim",
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "thejesbin",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim",
                                        fontSize: 14),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: mheight * 0.07,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Total Balance",
                                    style: TextStyle(
                                        color: Colors.grey.shade300,
                                        fontFamily: "Itim",
                                        fontSize: 13),
                                  ),
                                  Text(
                                    user.accountList[0].balance.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Get.to(() => ScreenAddCash());
                                  },
                                  child: Icon(Icons.add_circle,
                                      color: Colors.white)),
                              SizedBox(width: 18),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: 70,
                                alignment: Alignment.center,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "Send",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Itim",
                                      fontSize: 15),
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 70,
                                alignment: Alignment.center,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "Withdraw",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Itim",
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: mheight * 0.05,
                    ),
                    Column(
                      children: [
                        Obx(
                          () => following.isLoading.isTrue
                              ? SizedBox(
                                  height: 1,
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Quick Send",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Itim",
                                              fontSize: 14,
                                              letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 90,
                                      width: mwidth,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () => Get.to(() =>
                                                        ScreenSendCash(
                                                          profile: following
                                                              .followingList[i]
                                                              .profile
                                                              .toString(),
                                                          phone: following
                                                              .followingList[i]
                                                              .phone
                                                              .toString(),
                                                          uid: following
                                                              .followingList[i]
                                                              .id
                                                              .toString(),
                                                          username: following
                                                              .followingList[i]
                                                              .username
                                                              .toString(),
                                                        )),
                                                    child: Container(
                                                      height: 80,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              following
                                                                  .followingList[
                                                                      i]
                                                                  .profile
                                                                  .toString()),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: following
                                                  .followingList.length,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        history.isLoading.isTrue
                            ? CircularProgressIndicator()
                            : SizedBox(
                                height: mheight * 0.27,
                                width: mwidth,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "History",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Itim",
                                              fontSize: 20,
                                              letterSpacing: 1),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemBuilder: (context, i) {
                                          var data = history.historyList[i];
                                          return Container(
                                            alignment: Alignment.center,
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                      data.profile.toString()),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.title.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "Itim",
                                                          fontSize: 13,
                                                          letterSpacing: 1),
                                                    ),
                                                    Row(
                                                      children: [
                                                        data.type.toString() ==
                                                                "credit"
                                                            ? Icon(
                                                                Icons
                                                                    .call_received,
                                                                color: Colors
                                                                    .green,
                                                                size: 12,
                                                              )
                                                            : Icon(
                                                                Icons.call_made,
                                                                color:
                                                                    Colors.red,
                                                                size: 12,
                                                              ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  "₹ ${data.amount.toString()}",
                                                  style: TextStyle(
                                                      color: data.type
                                                                  .toString() ==
                                                              "credit"
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontFamily: "Itim",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      letterSpacing: 1),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: history.historyList.length,
                                      ),
                                    )
                                  ],
                                ),
                              )
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
