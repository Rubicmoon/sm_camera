import 'package:flutter/material.dart';

class CaptureButtonWidget extends StatelessWidget {
  final void Function() onTap;
  final bool showLoading;
  const CaptureButtonWidget({
    Key? key,
    required this.onTap,
    this.showLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showLoading ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 35,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
          ),
          if (showLoading)
            const Positioned.fill(
              child: CircularProgressIndicator(
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}
