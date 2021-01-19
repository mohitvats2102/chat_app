import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _userImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _userImage = File(pickedImage.path);
    });
    widget.imagePickFn(_userImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50,
          backgroundImage: _userImage == null
              ? AssetImage('assets/images/image.png')
              : FileImage(_userImage),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).accentColor,
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).accentColor,
          ),
          label: Text(
            'Add Image',
          ),
        ),
      ],
    );
  }
}
