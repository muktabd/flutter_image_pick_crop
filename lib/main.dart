import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickCrop(),
    );
  }
}

class ImagePickCrop extends StatefulWidget {
  ImagePickCrop({Key? key}) : super(key: key);

  @override
  _ImagePickCropState createState() => _ImagePickCropState();
}

class _ImagePickCropState extends State<ImagePickCrop> {
  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        cropTheImage(pickedFile);
        //_image = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
  }

  
  // cropper
  cropTheImage(pickedImage) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      maxWidth: 800,
    );

    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
        print("cropped image ===>>>> $_image");
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        getImage(ImageSource.camera);
                      });
                    },
                    child: Text("Camera"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _modalBottomSheetMenu(context);
                      });
                    },
                    child: Text("Gallery"),
                  ),
                ),
              ],
            ),
            //Image.file(_image!),

            Flexible(
              child: _image != null
                  ? Image.file(_image!)
                  : Image.asset(
                      "assets/images/person.png",
                      height: 200,
                      width: 150,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 350.0,
          padding: EdgeInsets.all(20),
           color: Colors.white,
          child: new Container(
            decoration: new BoxDecoration(
               
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: new Center(
              child: Column(
                children: [
                  Text("Pick from bottomsheet"),
                  new TextButton(
                    onPressed: () {
                      setState(() {
                        getImage(ImageSource.gallery);
                        // Navigator.pop(context);
                      });
                    },
                    child: Text("Pick"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
