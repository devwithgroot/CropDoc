import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageScreen extends StatefulWidget {
  const PickImageScreen({super.key});

  @override
  State<PickImageScreen> createState() => _PickImageScreen();
}

class _PickImageScreen extends State<PickImageScreen>
{
  File? _image;
  final _picker = ImagePicker();
  pickImage()
  async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile !=null)
      {
        _image =File(pickedFile.path);
        setState(() {

        });
      }
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
    body: Center(
      child: _image ==null
          ? const Text("No Image Picked")
          :Image.file(_image!),
    ),
      floatingActionButton: FloatingActionButton(
          onPressed:() {
            pickImage();
          },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
