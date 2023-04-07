import 'dart:async';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';

import '../../core/security.dart';
import '../screen_main/screen_main.dart';

class ScreenOtp extends StatefulWidget {
  final String name;
  final String email;
  final String profileUrl;
  final String gid;
  final String phone;
  ScreenOtp(
      {super.key,
      required this.name,
      required this.email,
      required this.profileUrl,
      required this.gid,
      required this.phone});

  @override
  State<ScreenOtp> createState() => _ScreenOtpState();
}

class _ScreenOtpState extends State<ScreenOtp> {
  ValueNotifier<int> buttonStatus = ValueNotifier(0);

  TextEditingController controller = TextEditingController();

  int timer = 60;
  late Timer time;
  runTimer() {
    time = Timer.periodic(Duration(seconds: 1), (t) {
      if (timer == 0) {
        time.cancel();
      } else {
        setState(() {
          timer--;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runTimer();
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: mheight * 0.02,
              ),
              Text(
                "Verification",
                style: const TextStyle(
                    color: Colors.white, fontSize: 30, fontFamily: "Itim"),
              ),
              SizedBox(
                height: mheight * 0.01,
              ),
              Lottie.asset(
                "assets/otp-anim.json",
                height: 200,
              ),
              SizedBox(
                height: mheight * 0.03,
              ),
              Text(
                "Hey ${widget.name} an OTP has been send to",
                style: const TextStyle(
                    color: Colors.grey, fontSize: 15, fontFamily: "Itim"),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "+91 ${widget.phone}",
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: "Itim"),
              ),
              SizedBox(
                height: mheight * 0.1,
              ),
              Pinput(
                length: 6,
                controller: controller,
                defaultPinTheme: PinTheme(
                    height: 48,
                    width: 48,
                    textStyle:
                        TextStyle(color: Colors.white, fontFamily: "Mukta"),
                    decoration: BoxDecoration(
                        color: bgSecondaryColor,
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(
                height: mheight * 0.05,
              ),
              Text(
                "Did'nt received OTP?",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Itim",
                  fontSize: 16,
                ),
              ),
              timer == 0
                  ? TextButton(
                      onPressed: () {
                        if (buttonStatus.value == 1) {
                        } else {
                          resendOtp();
                          buttonStatus.value = 1;
                        }
                      },
                      child: ValueListenableBuilder(
                          valueListenable: buttonStatus,
                          builder: (context, val, child) {
                            return buttonStatus.value == 1
                                ? SizedBox(height: 0,width: 0,)
                                : Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: "Itim",
                                      fontSize: 16,
                                    ),
                                  );
                          }),
                    )
                  : Text(
                      timer.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Itim",
                        fontSize: 15,
                      ),
                    ),
              SizedBox(
                height: mheight * 0.13,
              ),
              InkWell(
                onTap: () {
                  if (buttonStatus.value == 1) {
                  } else {
                    buttonStatus.value = 1;
                    register();
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
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: val == 1
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Itim",
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                      );
                    }),
              ),
              SizedBox(
                height: mheight * 0.05,
              )
            ],
          ),
        )),
      ),
    );
  }

  resendOtp() async {
    //send otp
    d.Dio dio = d.Dio();
    final formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "email": encrypt(widget.email),
      "phone": encrypt(widget.phone)
    });
    final response = await dio.post(sendOtpUrl,
        data: formData,
        options: d.Options(
          contentType: d.Headers.formUrlEncodedContentType,
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      buttonStatus.value = 0;
      if (response.data['status'] == true) {
        Get.offAll(() => ScreenOtp(
              name: widget.name,
              email: widget.email,
              gid: widget.gid,
              profileUrl: widget.profileUrl,
              phone: widget.phone,
            ));
        Get.snackbar("Hey Hy", response.data['msg'],
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Oh no", response.data['msg'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      buttonStatus.value = 0;
    }
  }

  register() async {
    var otp = controller.text;
    if (otp.length != 6) {
      Get.snackbar("Oh no", "Invalid otp",
          backgroundColor: Colors.red, colorText: Colors.white);
      buttonStatus.value = 0;
    } else {
      d.Dio dio = d.Dio();
      final formData = d.FormData.fromMap({
        "api": encrypt(apiKey),
        "email": encrypt(widget.email),
        "phone": encrypt(widget.phone),
        "gid": encrypt(widget.gid),
        "profile": encrypt(widget.profileUrl),
        "otp": encrypt(otp),
        "name": encrypt(widget.name)
      });
      final response = await dio.post(registerUrl,
          data: formData,
          options: d.Options(
            contentType: d.Headers.formUrlEncodedContentType,
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        buttonStatus.value = 0;
        if (response.data['status'] == true) {
          Get.snackbar("Hey Hy", response.data['msg'],
              backgroundColor: Colors.green, colorText: Colors.white);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("uid", response.data['uid']);
          Get.offAll(() => ScreenMain());
        } else {
          Get.snackbar("Hey Hy", response.data['msg'],
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        buttonStatus.value = 0;
      }
    }
  }
}
