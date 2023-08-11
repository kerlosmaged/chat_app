// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File? pickedImage) imagePickfun;
  const UserImagePicker({
    required this.imagePickfun,
    Key? key,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImagefilePic;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    XFile? pickedImagefile =
        await _picker.pickImage(source: src, imageQuality: 50, maxWidth: 150);
    if (pickedImagefile == null) {
      return;
    } else {
      setState(() {
        pickedImagefilePic = File(pickedImagefile.path);
      });
      widget.imagePickfun(pickedImagefilePic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: pickedImagefilePic != null
              ? FileImage(File(pickedImagefilePic!.path))
              : null,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_enhance),
                    label: const Text(
                      'Add image\nfrom camera',
                      textAlign: TextAlign.center,
                    ),
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.pink)),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text(
                      'Add image\nfrom gallery',
                      textAlign: TextAlign.center,
                    ),
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.pink)),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
