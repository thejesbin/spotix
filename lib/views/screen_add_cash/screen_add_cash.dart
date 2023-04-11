import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../core/security.dart';
import '../../viewmodels/account_viewmodel.dart';
import '../../core/constants.dart';
import '../../viewmodels/history_viewmodel.dart';
import 'add_money_failed.dart';
import 'add_money_success.dart';

class ScreenAddCash extends StatelessWidget {
  ScreenAddCash({super.key});
  ValueNotifier<String> amountText = ValueNotifier("0");
  ValueNotifier<bool> buttonStatus = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    var user = Get.put(AccountViewmodel());
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
              height: mheight * 0.1,
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
                    onTap: () {
                      if (buttonStatus.value) {
                      } else {
                        buttonStatus.value = true;
                        payment(user);
                      }
                    },
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
                      child: buttonStatus.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Processing payment...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Itim",
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
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

  payment(AccountViewmodel user) async {
    Razorpay razorpay = Razorpay();
    var amt = double.parse(amountText.value);
    var amount = amt * 100;
    var options = {
      'key': razorpayKey,
      'amount': amount.toString(),
      'name': user.accountList[0].name.toString(),
      'description': "Add money",
      'retry': {'enabled': true, 'max_count': 1},
      'prefill': {
        'contact': user.accountList[0].phone.toString(),
        'email': user.accountList[0].email.toString()
      }
    };
    razorpay.open(options);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentfailed);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, () {
      print("external wallet");
    });
  }

  handlePaymentSuccess(PaymentSuccessResponse r) async {
    var user = Get.put(AccountViewmodel());
    var history = Get.put(HistoryViewmodel());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    d.Dio dio = d.Dio();
    final formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "uid": encrypt(uid!),
      "tid": encrypt(r.paymentId!),
      "amount": encrypt(amountText.value),
    });
    final response = await dio.post(addMoneyUrl,
        data: formData,
        options: d.Options(
          contentType: d.Headers.formUrlEncodedContentType,
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      buttonStatus.value = false;
      if (response.data['status'] == true) {
        Get.off(() => AddMoneySuccess(paymentId: r.paymentId));
      } else {
        Get.off(() => AddMoneyFailed());
      }
      user.getData();
      history.getData();
    } else {
      buttonStatus.value = false;
      Get.off(() => AddMoneyFailed());
      Get.snackbar("Oh no", "Payment failed!",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  handlePaymentfailed(PaymentFailureResponse response) {
    Get.off(() => AddMoneyFailed());
    buttonStatus.value = false;
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
