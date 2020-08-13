import 'dart:io';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {

  final String localPath;
  final String uploadPath;

  const ImageContainer({@required this.localPath, @required this.uploadPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Hero(
        tag: uploadPath,
        child: InkWell(
            onTap: () => _onTap(context, uploadPath),
            child: FittedBox(
                child: Image.file(File(localPath)), fit: BoxFit.fill)
        ),
      ),
    );
  }

  void _onTap(BuildContext context, String uploadPath) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Image from Amazon'),
            ),
            body: Container(
              color: Colors.lightBlueAccent,
              child: Image.network(uploadPath)
            ),
          );
        }
    ));
  }
}
