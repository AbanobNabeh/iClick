import 'package:flutter/material.dart';
import 'package:iclick/core/componennts/app_components.dart';

Future<T?> showConfirmationDialog<T>(
  BuildContext context, {
  required String title,
  String? desc,
  String leftText = "Cancel",
  String rightText = "Discard",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Components.defText(
          text: title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desc != null) Components.defText(text: desc, size: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Components.defText(text: leftText, size: 16),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Components.defText(text: rightText, size: 16),
          )
        ],
      );
    },
  );
}

Future<T?> showconfrimdeleteitem<T>(BuildContext context,
    {required String title,
    String? desc,
    String leftText = "Cancel",
    String rightText = "Delete",
    void Function()? onPressed}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Components.defText(
          text: title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desc != null) Components.defText(text: desc, size: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Components.defText(text: leftText, size: 16),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Components.defText(text: rightText, size: 16),
          )
        ],
      );
    },
  );
}
