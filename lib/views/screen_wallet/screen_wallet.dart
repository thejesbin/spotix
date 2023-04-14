import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';
import 'package:spotix/views/screen_splash/screen_splash.dart';

import '../../models/history_model.dart';
import '../../viewmodels/following_viewmodel.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../screen_add_cash/screen_add_cash.dart';
import '../screen_send_cash/screen_send_cash.dart';
import '../screen_withdraw/screen_withdraw.dart';

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
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: mheight * 0.4,
                      width: mwidth,
                      decoration: const BoxDecoration(
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
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();
                                  Get.offAll(() => const ScreenSplash());
                                },
                                child: const Icon(
                                  Icons.drag_handle_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
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
                                    user.accountList[0].username.toString(),
                                    style: const TextStyle(
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
                              const SizedBox(
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
                                    "₹${user.accountList[0].balance}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    Get.to(() => ScreenAddCash());
                                  },
                                  child: const Icon(Icons.add_circle,
                                      color: Colors.white)),
                              const SizedBox(width: 18),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () => showSearchUser(context),
                                child: Container(
                                  height: 70,
                                  alignment: Alignment.center,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Text(
                                    "Send",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim",
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => Get.to(() => ScreenWithdraw()),
                                child: Container(
                                  height: 70,
                                  alignment: Alignment.center,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Text(
                                    "Withdraw",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Itim",
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                          const SizedBox(
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
                              ? const SizedBox(
                                  height: 1,
                                )
                              : following.followingList.isEmpty
                                  ? const SizedBox(height: 1)
                                  : Column(
                                      children: [
                                        Row(
                                          children:const [
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () => Get.to(
                                                            () =>
                                                                ScreenSendCash(
                                                                  profile: following
                                                                      .followingList[
                                                                          i]
                                                                      .profile
                                                                      .toString(),
                                                                  phone: following
                                                                      .followingList[
                                                                          i]
                                                                      .phone
                                                                      .toString(),
                                                                  receiverId: following
                                                                      .followingList[
                                                                          i]
                                                                      .id
                                                                      .toString(),
                                                                  username: following
                                                                      .followingList[
                                                                          i]
                                                                      .username
                                                                      .toString(),
                                                                )),
                                                        child: Container(
                                                          height: 80,
                                                          width: 70,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            image:
                                                                DecorationImage(
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
                            ? const CircularProgressIndicator()
                            : history.historyList.isEmpty
                                ? const SizedBox(height: 1)
                                : SizedBox(
                                    height: mheight * 0.27,
                                    width: mwidth,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: const[
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
                                              return InkWell(
                                                onTap: () => transactionDetails(
                                                    context, data),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 60,
                                                  width: double.infinity,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(data
                                                                .profile
                                                                .toString()),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.title
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "Itim",
                                                                fontSize: 13,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                          Row(
                                                            children: [
                                                              data.type.toString() ==
                                                                      "credit"
                                                                  ? const Icon(
                                                                      Icons
                                                                          .call_received,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 12,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .call_made,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 12,
                                                                    ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const Spacer(),
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
                                                      const SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount:
                                                history.historyList.length,
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

  transactionDetails(BuildContext context, HistoryModel data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(2),
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bgColor,
              ),
              width: 250,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      data.type.toString() == "credit"
                          ? const Icon(
                              Icons.call_received,
                              color: Colors.green,
                              size: 18,
                            )
                          : const Icon(
                              Icons.call_made,
                              color: Colors.red,
                              size: 18,
                            ),
                      Spacer(),
                      Text(
                        data.date.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "Itim",
                            fontSize: 9,
                            letterSpacing: 186),
                      ),
                      SizedBox(width:5),
                      Text(
                        data.time.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "Itim",
                            fontSize: 9,
                            letterSpacing: 1),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close, color: Colors.white))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.profile.toString()),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.title.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Itim",
                        fontSize: 13,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "₹ ${data.amount.toString()}",
                    style: TextStyle(
                        color: data.type.toString() == "credit"
                            ? Colors.green
                            : Colors.red,
                        fontFamily: "Itim",
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        letterSpacing: 1),
                  ),
                  Spacer(),
                  Text(
                    "ID: ${data.transactionID}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Itim",
                        fontSize: 13,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSearchUser(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var searchData = Get.put(SearchViewmodel());
          ValueNotifier<int> isSearching = ValueNotifier(0);
          return ValueListenableBuilder(
              valueListenable: isSearching,
              builder: (context, val, child) {
                return SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      color: bgSecondaryColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CupertinoSearchTextField(
                              onChanged: (String text) {
                                if (text.length > 0) {
                                  isSearching.value = 0;
                                }
                                {
                                  isSearching.value = 1;
                                  searchData.getData(text);
                                }
                              },
                              itemColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Itim",
                              ),
                            ),
                          ),
                          isSearching.value == 1
                              ? Obx(() => searchData.isLoading.isTrue
                                  ? const Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : searchData.searchList.isEmpty
                                      ? const Text(
                                          "No Data",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Itim"),
                                        )
                                      : buildSearchResult(context, searchData))
                              : const Center(
                                  child: Text(
                                    "Search & select receiver...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Itim"),
                                  ),
                                )
                        ],
                      )),
                );
              });
        },
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget buildSearchResult(BuildContext context, SearchViewmodel searchData) {
    return Expanded(
        child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              var id = searchData.searchList[i].id.toString();
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var uid = sharedPreferences.getString("uid");
              if (uid == id) {
                Navigator.pop(context);
                Get.snackbar("Oh no", "Its your own account",
                    colorText: Colors.white, backgroundColor: Colors.red);
              } else {
                Navigator.pop(context);
                Get.to(() => ScreenSendCash(
                    profile: searchData.searchList[i].profile.toString(),
                    phone: searchData.searchList[i].phone.toString(),
                    receiverId: searchData.searchList[i].id.toString(),
                    username: searchData.searchList[i].username.toString()));
              }
            },
            child: Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        searchData.searchList[i].profile.toString()),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    searchData.searchList[i].username.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Itim",
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  searchData.searchList[i].verified == "yes"
                      ? Image.asset("assets/verified.png", height: 15)
                      : const SizedBox(width: 1),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: searchData.searchList.length,
    ));
  }
}
