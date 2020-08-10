import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'notif.dart';
import 'global_functions.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String bs64;

class Profile extends StatefulWidget{
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile>{
  File _pickedImage;

  void _upload(File file) async {
    if (file == null) return;
    bs64 = base64Encode(file.readAsBytesSync());
    String fileName = usr.id + ".jpg";
    http.post("https://duline.mn/image.php", body: {
      "image": bs64,
      "name": fileName,
      "phone": usr.phone,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text("Миний мэдээлэл", style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Notif()));
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.person_outline),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: colorCyan,
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: ClipOval(
                      child: new SizedBox(
                        height: 140,
                        width: 140,
                        child: propic(bs64),
                      )
                  ),
                ),

                Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: (){
                        setState(() {
                            _showPickOptionsDialog(context);
                          });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: Text("ID: ${usr.id}", style: TextStyle(color: Colors.white),),
          ),
          SizedBox(height: 20,),
          Center(
            child: Text("${usr.ovog} ${usr.ner}", style: TextStyle(color: Colors.white, fontSize: 18),),
          ),
          SizedBox(height: 20,),
          _info(usr.bornDate == null ? "" : usr.bornDate, Icon(Icons.date_range, color: colorCyan,)),
          _info(usr.phone == null ? "" : usr.phone, Icon(Icons.phone, color: colorCyan,)),
          _info(usr.sex == null ? "" : usr.sex, Icon(Icons.accessibility_new, color: colorCyan,)),
          _info(usr.address == null ? "Хаяг" : usr.address, Icon(Icons.location_on, color: colorCyan,)),
          _info(usr.bank == '0' ? "Дансны мэдээлэл" : usr.bank, Icon(Icons.credit_card, color: colorCyan,)),
          SizedBox(height: 20,),
          Container(
            height: 1,
            width: double.infinity,
            color: colorCyan,
          ),
          SizedBox(height: 20,),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: QrImage(
                data: usr.id,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell _info(String txt, Icon icon){
    return InkWell(
      onTap: (){

      },
      child: ListTile(
        leading: icon,
        title: Text(txt, style: TextStyle(color: Colors.white),),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey,),
      ),
    );
  }

  _loadPicker(ImageSource source) async {
    File picked = await ImagePicker.pickImage(source: source, maxHeight: 600, maxWidth: 600, imageQuality: 100);
    if (picked != null) {
      _cropImage(picked);
    }
    Navigator.pop(context);
  }

  _cropImage(File picked) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: colorCyan,
        toolbarColor: colorCyan,
        activeControlsWidgetColor: colorCyan,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
        _upload(_pickedImage);
      });
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              onTap: () {
                _loadPicker(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Take a pictuer"),
              onTap: () {
                _loadPicker(ImageSource.camera);
              },
            )
          ],
        ),
      ),
    );
  }

}