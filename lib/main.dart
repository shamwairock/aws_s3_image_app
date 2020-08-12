import 'package:aws_s3/aws_s3.dart';
import 'package:aws_s3_image_app/image_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS S3 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'AWS S3 Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<PickedFile> _pickedFiles = [];
  final picker = ImagePicker();

  //to ensure image is uploading from the native android
  bool isFileUploading = false;

  String poolId;
  String awsFolderPath;
  String bucketName;

  @override
  void initState() {
    super.initState();
    readEnv();
  }

  void readEnv() async {
    final str = await rootBundle.loadString(".env");
    print(str);
    if (str.isNotEmpty) {
      final decoded = jsonDecode(str);
      poolId = decoded["poolId"];
      awsFolderPath = decoded["awsFolderPath"];
      bucketName = decoded["bucketName"];
    }

  }

  Future<String> _uploadImage() async {
    String result;

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    var uuid = Uuid().v4().replaceAll('-', '');
    var fileName = "${uuid}_${DateTime
        .now()
        .millisecondsSinceEpoch}.jpg";

    print(fileName);

    AwsS3 awsS3 = AwsS3(
        awsFolderPath: awsFolderPath,
        file: File(pickedFile.path),
        fileNameWithExt: fileName,
        poolId: poolId,
        region: Regions.AP_SOUTHEAST_1,
        bucketName: bucketName);

    setState(() => isFileUploading = true);
    //displayUploadDialog(awsS3);

    try {
      try {
        result = await awsS3.uploadFile;

        debugPrint("Result :'$result'.");
      } on PlatformException {
        debugPrint("Result :'$result'.");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed :'${e.message}'.");
    }

    //Navigator.of(context).pop();

    if (result != null) {
      setState(() {
        _pickedFiles.add(pickedFile);
      });
    }
    else {
     print('failed to upload');
    }

    return result;
  }

  Future displayUploadDialog(AwsS3 awsS3) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder(
        stream: awsS3.getUploadStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return buildFileUploadDialog(snapshot, context);
        },
      ),
    );
  }

  AlertDialog buildFileUploadDialog(
      AsyncSnapshot snapshot, BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: EdgeInsets.all(6),
        child: LinearProgressIndicator(
          value: (snapshot.data != null) ? snapshot.data / 100 : 0,
          valueColor:
          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text('Uploading...')),
            Text("${snapshot.data ?? 0}%"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: List.generate(_pickedFiles.length, (index) {
            return ImageContainer(imagePath: _pickedFiles[index].path);
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadImage(),
        child: Icon(Icons.cloud_upload),
      ),
    );
  }
}
