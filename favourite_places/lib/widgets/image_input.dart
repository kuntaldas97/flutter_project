import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget{
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}
class _ImageInputState extends State<ImageInput>{
  void _takePicture(){
    final imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.camera,maxHeight: 600);
  }
  @override
  Widget build(BuildContext context) {
   return Container(
    height: 250,
    width: double.infinity,
    alignment: Alignment.center,
    child: TextButton.icon(
      icon: Icon(Icons.camera),
      onPressed: _takePicture, 
      label: Text("Take Picture")),
   );
  }
}