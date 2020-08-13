import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class ImagePlaceholder extends StatelessWidget {

  final String networkPath;
  const ImagePlaceholder({
    Key key,
    this.networkPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image from Amazon'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () => _downloadImage(context),
          ),
        ],
      ),
      body: Container(
          color: Colors.lightBlueAccent,
          child: Image.network(networkPath)
      ),
    );
  }

  _downloadImage(BuildContext context) async{
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(networkPath);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);

      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text('Success'),
            content: Text('File download success: ' + fileName),
          ),
      );
    } on PlatformException catch (error) {
      print(error);
    }
  }
}