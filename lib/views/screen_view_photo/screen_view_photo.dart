import 'package:flutter/material.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/views/widgets/photos_widget.dart';

class ScreenViewPhoto extends StatelessWidget {
  final String id;
  final String pid;
  final String profileUrl;
  final String username;
  final String postUrl;
  final String isLiked;
  final String likes;
  final String verified;
  final String caption;
  const ScreenViewPhoto(
      {super.key,
      required this.pid,
      required this.profileUrl,
      required this.username,
      required this.postUrl,
      required this.isLiked,
      required this.likes,
      required this.verified,
      required this.caption, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          PhotosWidget(
            id: id,
              pid: pid,
              profileUrl: profileUrl,
              username: username,
              postUrl: postUrl,
              isLiked: isLiked,
              likes: likes,
              verified: verified,
              caption: caption),
        ],
      ),
    );
  }
}
