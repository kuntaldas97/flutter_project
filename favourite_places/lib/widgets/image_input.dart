import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget{
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}
class _ImageInputState extends State<ImageInput>{
 void _selectImageSource() {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
}
void _pickImage(ImageSource source) async {
  final imagePicker = ImagePicker();
  File? _selectedImage;
  final pickedImage = await imagePicker.pickImage(
    source: source,
    maxHeight: 600,
  );

  if (pickedImage == null) return;

  // You can store or display the image here
  _selectedImage = File(pickedImage.path);
}
  @override
  Widget build(BuildContext context) {
   return Container(
    height: 250,
    width: double.infinity,
    alignment: Alignment.center,
    child: TextButton.icon(
      icon: Icon(Icons.camera),
      onPressed: _selectImageSource, 
      label: Text("Select Image")),
   );
  }
}