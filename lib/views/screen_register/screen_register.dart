import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

import '../../core/security.dart';
import '../screen_otp/screen_otp.dart';

class ScreenRegister extends StatelessWidget {
  final String name;
  final String email;
  final String profileUrl;
  final String gid;
  ScreenRegister(
      {super.key,
      required this.name,
      required this.email,
      required this.profileUrl,
      required this.gid});
  ValueNotifier<int> buttonStatus = ValueNotifier(0);
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: mheight * 0.05,
            ),
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(profileUrl),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Hi $name",
              style: const TextStyle(
                  color: Colors.white, fontSize: 25, fontFamily: "Itim"),
            ),
            SizedBox(
              height: mheight * 0.1,
            ),
            Container(
              alignment: Alignment.center,
              height: 70,
              width: mwidth * 0.92,
              decoration: BoxDecoration(
                  color: bgSecondaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.phone_android_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        if (val.length >= 10) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Itim"),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Phone number",hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                if (buttonStatus.value == 1) {
                } else {
                  buttonStatus.value = 1;
                  sendOtp();
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
    );
  }

  sendOtp() async {
    var phone = phoneController.text;
    if (phone.length != 10) {
      Get.snackbar("Oh no", "Invalid phone number",
          backgroundColor: Colors.red, colorText: Colors.white);
      buttonStatus.value = 0;
    } else {
      //send otp
      d.Dio dio = d.Dio();
      final formData = d.FormData.fromMap({
        "api": encrypt(apiKey),
        "email": encrypt(email),
        "phone": encrypt(phone)
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
                name: name,
                email: email,
                gid: gid,
                profileUrl: profileUrl,
                phone: phone,
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
  }
}
