import 'package:flutter/material.dart';

class ImageActionButton extends StatelessWidget {
  final void Function() onRetry;
  final void Function() onOk;
  const ImageActionButton({
    Key? key,
    required this.onRetry,
    required this.onOk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: onRetry,
          child: const Text(
            "RETRY",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: onOk,
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
