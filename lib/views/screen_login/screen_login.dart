import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/views/screen_register/screen_register.dart';
import '../../core/constants.dart';
import '../screen_main/screen_main.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});
  ValueNotifier<int> buttonStatus = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return Container(
      color: bgColor,
      child: Column(
        children: [
          Image.asset("assets/login-anim.gif"),
          SizedBox(
            height: mheight * 0.05,
          ),
          Text(
            "Login",
            style: const TextStyle(
                color: Colors.white, fontSize: 23, fontFamily: "Itim"),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Login to continuee with $appName",
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: "Itim"),
            ),
          ),
          SizedBox(
            height: mheight * 0.1,
          ),
          InkWell(
            onTap: () {
              if (buttonStatus.value == 1) {
              } else {
                login();
                buttonStatus.value = 1;
              }
            },
            child: ValueListenableBuilder(
                valueListenable: buttonStatus,
                builder: (context, val, child) {
                  return Container(
                    height: 70,
                    width: mwidth * 0.9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: val == 1
                        ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Continue with",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Itim",
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/google.png",
                                height: 40,
                              )
                            ],
                          ),
                  );
                }),
          )
        ],
      ),
    );
  }

  login() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.signOut();
      buttonStatus.value = 0;
    } else {
      await googleSignIn.signIn();
      if (await googleSignIn.isSignedIn()) {
        var name = googleSignIn.currentUser!.displayName;
        var email = googleSignIn.currentUser!.email;
        var profileUrl = googleSignIn.currentUser!.photoUrl;
        var gid = googleSignIn.currentUser!.id;
        d.Dio dio = d.Dio();
        final formData = d.FormData.fromMap(
            {"api": encrypt(apiKey), "email": encrypt(email)});
        final response = await dio.post(checkAccountUrl,
            data: formData,
            options: d.Options(
              contentType: d.Headers.formUrlEncodedContentType,
            ));
        if (response.statusCode == 200 || response.statusCode == 201) {
          buttonStatus.value = 0;
          if (response.data['status'] == true) {
            //got to home
            Get.snackbar("Hey Hey", response.data['msg'],
                colorText: Colors.white, backgroundColor: Colors.green);
            SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            sharedPreferences.setString("uid", response.data['uid']);
            Get.offAll(()=>ScreenMain());
          } else {
            Get.to(() => ScreenRegister(
                name: name!, email: email, profileUrl: profileUrl!, gid: gid));
            Get.snackbar("Hey Hey", response.data['msg'],
                colorText: Colors.white, backgroundColor: Colors.green);
          }
        } else {
          buttonStatus.value = 0;
        }
      } else {
        Get.snackbar("Oh no", "Login Failed",
            backgroundColor: Colors.red, colorText: Colors.white);
        buttonStatus.value = 0;
      }
    }
  }
}
