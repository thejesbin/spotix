import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/views/screen_onboarding/screen_onboarding.dart';
import 'package:spotix/views/screen_splash/screen_splash.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'core/constants.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Firebase.initializeApp();

  /// 1.1 define a navigator key
  final navigatorKey = GlobalKey<NavigatorState>();

  /// 1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  runApp(MyApp(navigatorKey: navigatorKey));
  // ZegoUIKit().initLog().then((value) => runApp(MyApp()));
  HttpOverrides.global = PostHttpOverrides();
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    var uname = sharedPreferences.getString("uname");

    if (uid != null && uname != null) {
      onUserLogin(uid, uname);
      print("Uname : $uname");
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: ScreenSplash(),
    );
  }

  /// on App's user login
  void onUserLogin(String uid, String uname) {
    /// 2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: zegoCloudAppId,
      appSign: zegoCloudAppSign,
      userID: uid,
      userName: uname,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  /// on App's user logout
  void onUserLogout() {
    /// 2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
