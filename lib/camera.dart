import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bar/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

import 'signUp.dart';
import 'main.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

List<CameraDescription> cameras;
class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  int selectedCameraIndex;
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _upload(File file) async {
    if (file == null) return;
    String bs64 = base64Encode(file.readAsBytesSync());
    String fileName = phone == null ? "12345678" + ".jpg" : phone + ".jpg";
    http.post("https://duline.mn/image2.php", body: {
      "image": bs64,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _cameraPreviewWidget(),
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                color: Colors.black45,
                child: Center(
                  child: Align(
                    child: Text(
                        'Эргэний үнэмлэхний зурагаа\nдарна уу.', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                //color: Colors.black26,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                color: Colors.black45,
                child: Center(
                  child: Align(
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _onCapturePressed(context);
                      },
                    )
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }
  void _onCapturePressed(context) async {
    try {
      File pic;
      final path =
      join((await getTemporaryDirectory()).path, '${DateTime.now()}.jpg');
      await controller.takePicture(path);
      print(path);
      pic = File(path);
      //String p = path;

      //File picked;// = await image.copy(p);
      print("hoho");
      _upload(pic);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(imgPath: path,)),);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()),);
    } catch (e) {
      _showCameraException(e);
    }
  }
}