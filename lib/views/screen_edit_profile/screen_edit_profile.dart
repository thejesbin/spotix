import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotix/core/constants.dart';

import '../../viewmodels/account_viewmodel.dart';

class ScreenEditProfile extends StatelessWidget {
  ScreenEditProfile({super.key});
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var account = Get.put(AccountViewmodel());
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    phoneController.text = account.accountList[0].phone.toString();
    bioController.text = account.accountList[0].bio.toString();

    userNameController.text = account.accountList[0].username.toString();
    nameController.text = account.accountList[0].name.toString();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: account.isLoading.isTrue
            ? SizedBox(
                width: 1,
              )
            : Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        NetworkImage(account.accountList[0].profile.toString()),
                    radius: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    account.accountList[0].username.toString(),
                    style: const TextStyle(
                      fontFamily: "Itim",
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 10,
                  ),
                ),
              ],
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
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        if (val.length >= 10) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 20, fontFamily: "Itim"),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone number",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),

            //username
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Username",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 10,
                  ),
                ),
              ],
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
                    Icons.verified_user,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Itim"),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Username",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),

            //name
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 10,
                  ),
                ),
              ],
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
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Itim"),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),

            //bio
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Bio",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Itim",
                    fontSize: 10,
                  ),
                ),
              ],
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
                    Icons.description_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Itim"),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Bio",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,
          width: mwidth * 0.9,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
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
        ),
      ),
    );
  }
}
