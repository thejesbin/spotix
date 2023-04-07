import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants.dart';

class AddMoneyFailed extends StatelessWidget {
  AddMoneyFailed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(children: [
          Lottie.asset("assets/try-again.json", repeat: false),
          Text(
            "Money adding Failed",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Itim",
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Spacer(),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
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
