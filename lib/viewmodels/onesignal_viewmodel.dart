import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../core/security.dart';

class OneSignalViewmodel extends GetxController {
  void configure() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId(oneSignalAppId);
    final state = await OneSignal.shared.getDeviceState();
    final String? one = state?.userId;
    d.Dio dio = d.Dio();
    var formData = d.FormData.fromMap({
      "api": encrypt(apiKey),
      "uid": encrypt(uid!),
      "one": encrypt(one!),
    });
    var response = await dio.post(notificationUrl,
        data: formData,
        options: d.Options(contentType: d.Headers.formUrlEncodedContentType));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    configure();
  }
}
