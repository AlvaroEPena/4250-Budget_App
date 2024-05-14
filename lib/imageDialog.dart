import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerDialog extends StatefulWidget {
  final void Function(File?) onImageSelected;

  const ImagePickerDialog({super.key, required this.onImageSelected});

  @override
  _ImagePickerDialogState createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      widget.onImageSelected(_image);
    }
  }

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      widget.onImageSelected(_image); // TODO: sending image back need to store it somewhere
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
