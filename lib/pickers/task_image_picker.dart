import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:getwidget/getwidget.dart';


class TaskImagePicker extends StatefulWidget {
 TaskImagePicker(this.imagePickFn);

  final Function(File pickedImage) imagePickFn;
  
  @override
  _TaskImagePickerState createState() => _TaskImagePickerState();
}

class _TaskImagePickerState extends State<TaskImagePicker> {
//Preview the image
  File _pickedImage;

//method to open the camera or use the image library
  void _pickImage() async {
    final pickImageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 80,maxWidth: 150);
    setState(() {
      _pickedImage = pickImageFile;
    });
    widget.imagePickFn(pickImageFile);
  }


  
  @override
  Widget build(BuildContext context) {
   return Column(
      children: <Widget>[
        
        Container(
          width: double.maxFinite,
          height: 200,
          child: GFAvatar(
            shape: GFAvatarShape.square,
            
            backgroundColor: Colors.grey,
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage) : null,
          ),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}