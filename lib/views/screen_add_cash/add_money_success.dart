import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants.dart';

class AddMoneySuccess extends StatelessWidget {
  String? paymentId;
  AddMoneySuccess({super.key, this.paymentId});

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
            "Money added successfully",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Itim",
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Payment ID : ${paymentId!}",
            style: TextStyle(
              color: Colors.grey,
              fontFamily: "Itim",
              fontSize: 12,
            ),
          ),
          Spacer(),
          InkWell(
            onTap:()=>Navigator.of(context).pop(),
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
          SizedBox(height: mheight*0.05,)
        ]),
      ),
    );
  }
}
