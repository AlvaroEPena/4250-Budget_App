import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:budget_manager/hive/transaction_box_operations.dart';

class ImagePickerDialog extends StatefulWidget {
  final void Function(String) onImageSelected;
  final String? imagePath;

  const ImagePickerDialog({super.key, required this.onImageSelected, required this.imagePath});

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      final file = File(widget.imagePath!);
      if (file.existsSync()) {
        _image = file;
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final savedPath = await saveImageLocally(File(pickedFile.path));
      setState(() {
        _image = File(savedPath!);
      });
      widget.onImageSelected(savedPath!);
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final savedPath = await saveImageLocally(File(pickedFile.path));
      setState(() {
        _image = File(savedPath!);
      });
      widget.onImageSelected(savedPath!); // send path back to
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Attach Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Attach Image from Gallery'),
          ),
          ElevatedButton(
            onPressed: _captureImage,
            child: const Text('Capture Image'),
          ),
          _image != null
              ? Image.file(_image!)
              : const Text('No image selected'),
        ],
      ),
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
