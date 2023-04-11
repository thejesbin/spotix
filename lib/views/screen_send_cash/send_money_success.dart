import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants.dart';
import '../screen_main/screen_main.dart';

class SendMoneySuccess extends StatelessWidget {
  String? paymentId;
  final String username;
  final String profile;
  final String amount;
  SendMoneySuccess(
      {super.key,
      this.paymentId,
      required this.username,
      required this.profile,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(children: [
          Lottie.asset("assets/succesfull.json", repeat: false),
          Text(
            "Payment Success to",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Itim",
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(profile),
                radius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                username,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Itim",
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "₹ $amount",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Itim",
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          paymentId == null
              ? Text(
                  "",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 12,
                  ),
                )
              : Text(
                  "Payment ID : ${paymentId!}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 12,
                  ),
                ),
          Spacer(),
          InkWell(
            onTap: () => Get.offAll(() => ScreenMain()),
            child: Container(
              height: 40,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 31, 94, 87),
                    Color.fromARGB(255, 42, 112, 102),
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Got IT",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Itim", fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            height: mheight * 0.05,
          )
        ]),
      ),
    );
  }
}
