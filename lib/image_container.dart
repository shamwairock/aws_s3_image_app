import 'dart:io';
import 'package:aws_s3_image_app/image_placeholder.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {

  final String localPath;
  final String networkPath;

  const ImageContainer({@required this.localPath, @required this.networkPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Hero(
        tag: networkPath,
        child: InkWell(
            onTap: () => _onTap(context, networkPath),
            child: FittedBox(
                child: Image.file(File(localPath)), fit: BoxFit.fill)
        ),
      ),
    );
  }

  void _onTap(BuildContext context, String uploadPath) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return ImagePlaceholder(networkPath: uploadPath,);
        }
    ));
  }
}

