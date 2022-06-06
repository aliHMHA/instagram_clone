import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

imagepicker(ImageSource imageee, BuildContext context) async {
  final ImagePicker _picker = ImagePicker();

  XFile? image = await _picker.pickImage(source: imageee);

  if (image != null) {
    return image;
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('no image was selected')));
  }
}

showsnackbarr(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
