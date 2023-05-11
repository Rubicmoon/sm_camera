import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sm_camera/sm_image/screen/sm_image_screen.dart';

class TakeImageScreen extends StatefulWidget {
  const TakeImageScreen({super.key});

  @override
  State<TakeImageScreen> createState() => _TakeImageScreenState();
}

class _TakeImageScreenState extends State<TakeImageScreen> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                imageFile = await SMImagePicker().captureImage(context);
                setState(() {});
              },
              child:
                  Text(imageFile != null ? "Take Another Image" : "Take Image"),
            ),
            if (imageFile != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Captured Image",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    width: 400,
                    child: Image.file(File(imageFile!.path)),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
