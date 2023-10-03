import 'package:flutter/material.dart';

Future<bool?> showPermanentPermissionDeniedHandlerDialog(
  BuildContext context, {
  required String message,
  required String openSettingsButtonText,
  required void Function() onOpenSettingsPressed,
}) async =>
    await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog.adaptive(
        content: Text(
          message,
        ),
        actions: [
          OutlinedButton(
            onPressed: onOpenSettingsPressed,
            child: Text(
              openSettingsButtonText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // Close the dialog
              Navigator.pop(context, true);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
