import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

class ScreenSendCash extends StatelessWidget {
  final String profile;
  final String phone;
  final String uid;
  final String username;

  ScreenSendCash({
    super.key,
    required this.profile,
    required this.phone,
    required this.uid,
    required this.username,
  });
  ValueNotifier<String> amountText = ValueNotifier("0");
  ValueNotifier<bool> buttonStatus = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var hiddenPhone = phone.substring(7, phone.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Cash"),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: mheight * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              height: 70,
              width: mwidth * 0.8,
              decoration: BoxDecoration(
                color: bgSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(image: NetworkImage(profile)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Itim",
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        "xxxxxxx$hiddenPhone",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "Itim",
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: amountText,
                builder: (context, val, child) {
                  return Text(
                    "₹${amountText.value}",
                    style: const TextStyle(
                        color: Colors.white, fontFamily: "Itim", fontSize: 60),
                  );
                }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNumber("1"),
                buildNumber("2"),
                buildNumber("3"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNumber("4"),
                buildNumber("5"),
                buildNumber("6"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNumber("7"),
                buildNumber("8"),
                buildNumber("9"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNumber("."),
                buildNumber("0"),
                buildIcon(),
              ],
            ),
            SizedBox(
              height: mheight * 0.03,
            ),
            ValueListenableBuilder(
                valueListenable: buttonStatus,
                builder: (context, val, child) {
                  return InkWell(
                    child: Container(
                      height: 70,
                      width: mwidth * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 31, 94, 87),
                                Color.fromARGB(255, 42, 112, 102),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Itim",
                            fontSize: 18),
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: mheight * 0.03,
            ),
          ],
        ),
      )),
    );
  }

  Widget buildIcon() {
    return InkWell(
      onTap: () {
        if (amountText.value.isNotEmpty) {
          amountText.value =
              amountText.value.substring(0, amountText.value.length - 1);
        } else {
          amountText.value = "0";
        }
      },
      child: Container(
        height: 60,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildNumber(number) {
    return InkWell(
      onTap: () {
        if (amountText.value.length < 6) {
          if (amountText.value == "0") {
            amountText.value = number;
          } else {
            amountText.value = amountText.value + number;
          }
        } else {}
      },
      child: Container(
        height: 60,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
              color: Colors.white, fontFamily: "Itim", fontSize: 28),
        ),
      ),
    );
  }
}
