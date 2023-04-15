import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:spotix/core/constants.dart';

import '../../core/security.dart';
import '../screen_main/screen_main.dart';

class ScreenUploadPhoto extends StatelessWidget {
  final File image;
  ScreenUploadPhoto({super.key, required this.image});
  TextEditingController captionController = TextEditingController();
  ValueNotifier<int> isUploading = ValueNotifier(0);
  ValueNotifier<int> uploadingPercentage = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(image), fit: BoxFit.contain),
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                controller: captionController,
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(
                    color: Colors.white, fontFamily: "Itim", fontSize: 13),
                decoration: InputDecoration(
                    fillColor: bgSecondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    hintText: "Enter Something",
                    hintStyle: const TextStyle(
                        color: Colors.white, fontFamily: "Itim", fontSize: 13)),
              )),
              const SizedBox(
                width: 10,
              ),
              ValueListenableBuilder(
                  valueListenable: isUploading,
                  builder: (context, val, child) {
                    return isUploading.value == 1
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : IconButton(
                            onPressed: () => uploadImage(),
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ));
                  }),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  uploadImage() async {
    var caption = captionController.text;
    if (caption.isEmpty) {
      Get.snackbar("Oh No!", "Enter a caption",
          colorText: Colors.white, backgroundColor: Colors.red);
    } else if (caption.length > 80) {
      Get.snackbar("Oh No!", "Maximum length is 80 characters",
          colorText: Colors.white, backgroundColor: Colors.red);
    } else {
      isUploading.value = 1;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString('uid');
      captionController.text="";
      FocusManager.instance.primaryFocus?.unfocus();
      Get.snackbar("", "",
          colorText: Colors.white,
          backgroundColor: bgColor,
          titleText: LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: primaryColor,
          ),
          messageText: Row(
            children: const [
              Text(
                "Uploading photo....",
                style: TextStyle(color: Colors.white, fontFamily: "Itim"),
              )
            ],
          ),
          duration: Duration(minutes: 5));
      d.Dio dio = d.Dio();
      var formdata = d.FormData.fromMap(
        {
          "image": await d.MultipartFile.fromFile(image.path),
          "uid": encrypt(uid!),
          "caption": encrypt(caption),
          "api": encrypt(apiKey)
        },
      );
      final response = await dio.post(uploadImageUrl,
          data: formdata,
          options: d.Options(contentType: d.Headers.formUrlEncodedContentType),
          onSendProgress: (actualBytes, totalBytes) {
        var p = actualBytes / totalBytes * 100;
        print(p);
        // if (p < 100) {
        //   uploadingPercentage.value = p.toInt();
        //   print(uploadingPercentage.value);
        // } else {
        //   isUploading.value = 0;
        //   uploadingPercentage.value = 0;
        // }
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        isUploading.value = 0;
        Get.closeAllSnackbars();
        if (response.data['status'] == true) {
          Get.snackbar("Hey Hey", response.data['msg'],
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAll(() => const ScreenMain());
        } else {
          Get.snackbar("Oh no", response.data['msg'],
              backgroundColor: Colors.red, colorText: Colors.white);
          Get.offAll(() => const ScreenMain());
        }
      } else {
         Get.closeAllSnackbars();
        isUploading.value = 0;
      }
    }
  }
}
