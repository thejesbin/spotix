import 'package:flutter/material.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/views/screen_login/screen_login.dart';
import 'package:spotix/views/widgets/onboarding_widget.dart';

class ScreenOnboarding extends StatelessWidget {
  const ScreenOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    ValueNotifier<int> pageIndex = ValueNotifier(0);
    var pages = [
      const OnboardingWidget(
        animation: "assets/gallery-anim.gif",
        title: "Post Videos",
        subtitle:
            "Upload photos & videos from your phone library or take pictures straight from your camera and share them with your followers",
      ),
      const OnboardingWidget(
        animation: "assets/wallet-anim.gif",
        title: "Live Payments",
        subtitle:
            "Upload photos & videos from your phone library or take pictures straight from your camera and share them with your followers",
      ),
      const OnboardingWidget(
        animation: "assets/live-anim.gif",
        title: "Watch Live TV",
        subtitle:
            "Upload photos & videos from your phone library or take pictures straight from your camera and share them with your followers",
      ),
       ScreenLogin()
    ];
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (i) {
                  pageIndex.value = i;
                },
                controller: controller,
                itemBuilder: (context, i) {
                  return pages[i];
                },
                itemCount: 4,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ValueListenableBuilder(
                valueListenable: pageIndex,
                builder: (context, val, child) {
                  return Row(
                    children: [
                      const Spacer(),
                      val == 3
                          ? const SizedBox(
                              height: 2,
                            )
                          : InkWell(
                              onTap: () {
                                controller.nextPage(
                                    duration: const Duration(
                                      microseconds: 500,
                                    ),
                                    curve: Curves.ease);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  );
                }),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
