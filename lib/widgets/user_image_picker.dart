import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;



  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _imagePick() async{
    final _picker = ImagePicker();
    final pickedImageFile = await _picker.pickImage(source: ImageSource.camera,
    imageQuality: 50,
    maxWidth: 150,
    );
    setState(() {
      //_pickedImage = pickedImageFile as File;
      _pickedImage = File(pickedImageFile!.path);
      widget.imagePickFn(_pickedImage!);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF0f388a),
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null
        ),
        TextButton.icon(
          onPressed: _imagePick,
          icon: const Icon(Icons.image,color: Color(0xFFf20202),),
          label: const Text('Add Image',style: TextStyle(
            color: Color(0xFFf20202),
          ),),
        ),
      ],
    );
  }
}
