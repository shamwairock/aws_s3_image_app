import 'dart:io';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {

  final String imagePath;

  const ImageContainer({@required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: InkWell(
          child: FittedBox(child: Image.file(File(imagePath)), fit: BoxFit.fill)
      ),
    );
  }
}
