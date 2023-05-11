// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CameraActionButton extends StatelessWidget {
  final void Function() onCameraChange;
  final void Function() onFlashLight;
  final bool isFlashOn;

  const CameraActionButton({
    Key? key,
    required this.onCameraChange,
    required this.onFlashLight,
    this.isFlashOn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onCameraChange,
          icon: const Icon(
            Icons.cameraswitch_outlined,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: onFlashLight,
          icon: Icon(
            isFlashOn ? Icons.flash_off : Icons.flash_on,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
