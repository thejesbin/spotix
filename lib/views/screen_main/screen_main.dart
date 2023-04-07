import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/viewmodels/account_viewmodel.dart';
import 'package:spotix/views/screen_account/screen_account.dart';
import 'package:spotix/views/screen_home/screen_home.dart';
import 'package:spotix/views/screen_search/screen_search.dart';
import 'package:spotix/views/screen_shorts/screen_shorts.dart';
import 'package:spotix/views/screen_wallet/screen_wallet.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Get.put(AccountViewmodel());
    var pages = [
      ScreenHome(),
      ScreenSearch(),
      ScreenShorts(),
      ScreenWallet(),
      ScreenAccount(),
    ];
    ValueNotifier<int> pageIndex = ValueNotifier(0);
    return ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (context, val, child) {
          return Obx(
            () => Scaffold(
              backgroundColor: bgColor,
              body: user.isLoading.isTrue
                  ? Center(child: CircularProgressIndicator())
                  : SafeArea(child: pages[val]),
              bottomNavigationBar: SalomonBottomBar(
                selectedItemColor: primaryColor,
                currentIndex: val,
                onTap: (i) {
                  pageIndex.value = i;
                },
                items: [
                  SalomonBottomBarItem(
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      title: const Text("Home")),
                  SalomonBottomBarItem(
                      icon: const Icon(
                        Icons.search_outlined,
                        color: Colors.white,
                      ),
                      title: const Text("Search")),
                  SalomonBottomBarItem(
                      icon: const Icon(
                        Icons.subscriptions,
                        color: Colors.white,
                      ),
                      title: const Text("Shorts")),
                  SalomonBottomBarItem(
                      icon: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                      ),
                      title: const Text("Wallet")),
                  SalomonBottomBarItem(
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                      ),
                      title: const Text("Account")),
                ],
              ),
            ),
          );
        });
  }
}
