import 'dart:io';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String? imagePath;

  const ImageDialog({
    super.key,
    this.imagePath
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transaction Image'),
      content: imagePath != null && File(imagePath!).existsSync() // check if a image path was given and also check if it exists
          ? Image.file(File(imagePath!))
          : const Text('No image available for this transaction'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
