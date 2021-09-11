import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends State {
  void getImage(File _image) async {
    File _img = (await ImagePicker.platform
        .pickImage(source: ImageSource.gallery)) as File;
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
