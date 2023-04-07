import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/views/screen_account/screen_account.dart';
import 'package:spotix/views/screen_main/screen_main.dart';
import 'package:spotix/views/screen_onboarding/screen_onboarding.dart';
import 'package:spotix/views/screen_wallet/screen_wallet.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () async{ 
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     var uid= sharedPreferences.getString("uid");
     if(uid==null){
      Get.offAll(()=>ScreenOnboarding());
     }
     else{
      Get.offAll(()=>ScreenMain());
     }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen")),
    );
  }
}
