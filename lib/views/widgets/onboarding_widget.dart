import 'package:flutter/material.dart';

import '../../core/constants.dart';

class OnboardingWidget extends StatelessWidget {
  final String animation;
  final String title;
  final String subtitle;
  const OnboardingWidget(
      {super.key,
      required this.animation,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Image.asset(animation),
           Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 23, fontFamily: "Itim"),
          ),
          const SizedBox(
            height: 10,
          ),
           Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: "Itim"),
            ),
          ),
        ],
      ),
    );
  }
}
