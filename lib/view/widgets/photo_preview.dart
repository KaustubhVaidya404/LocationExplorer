import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_colors.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key, required this.image});
  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundBlue,
      appBar: AppBar(
        backgroundColor: backGroundBlue,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.all(2),
          child: const Text(
            'Location Explorer',
            style: TextStyle(fontSize: 25, color: appBarFontBlack),
          ),
        ),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(image.path), fit: BoxFit.fill, width: 250),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Icon(
              Icons.arrow_circle_right_outlined,
              size: 45,
            ),
            style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(backGroundBlue)),
          ),
        ]),
      ),
    );
  }
}
