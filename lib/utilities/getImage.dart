import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class GetImage extends State{

    void getImage(File _image) async {
      var _img = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = _img;
        print(_image.path);
      });
    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
