import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'profile.dart';
import 'notif.dart';
import 'choose.dart';
import 'map.dart';
import 'listView.dart';
import 'QRrate.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location/location.dart';

class Dashboard extends StatefulWidget{
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{
  Location location = new Location();
  double _space = 15;
  String qrcode;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Future _scan() async {
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      qrcode = barcode;
      _getUserById(qrcode);
    }
  }

  Future _toMap() async{
    LocationData _locationResult = await location.getLocation();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Map(lat: _locationResult.latitude, lng: _locationResult.longitude)));
  }

  Future _getUserById(String _id) async {
    ProgressDialog pr = ProgressDialog(context);
    pr.style(
        message: 'Түр хүлээн үү...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        //textDirection: TextDirection.rtl,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    var url = "https://duline.mn/get_usr_by_id.php";
    var data = {'id': int.parse(_id)};
    var response = await http.post(url, body: json.encode(data));
    var jsonData = json.decode(response.body);
    if (jsonData != null) {
      var u = jsonData;
      qrusr =
          QRuser(_id, u["ovog"], u["ner"], u["born"], u["sex"]);
      await pr.hide();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRrate())
      );
    } else {
      await pr.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseMessaging.subscribeToTopic(usr.id);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Удирдах самбар", style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Notif()));
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 30,
                ),
                Card(
                  child: Container(
                    height: 100,
                    width: 300,
                  ),
                  color: Colors.white,
                ),
                Card(
                  child: Container(
                    height: 100,
                    width: 300,
                  ),
                  color: Colors.white,
                ),
                Container(
                  width: 30,
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Үйлчилгээний төрлүүд",
              style: TextStyle(
                color: colorCyan,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              crossAxisSpacing: 20,
              mainAxisSpacing: 25,
              childAspectRatio: 0.70,
              children: <Widget>[
                btn("Хүргэлтийн үйлчилгээ", "assets/logo/Hurgelt@300x.png", '0', "deliver1"),
                btn("Цагийн ажил", "assets/logo/tsagiin ajil@300x.png", '0', "part_time"),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListV(title: "Такси дуудлага", table: "taxi",)));
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/logo/taxi@300x.png"),
                        width: 100,
                      ),
                      Text("Такси дуудлага", style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                btn("Хүүхэд хүргэх", "assets/logo/Huuhed hurgelt@300x.png", '1', "child"),
                btn("Хүүхэд харах", "assets/logo/Huuhed harah@300x.png", '0', "child_care"),
                btn("Дуудлагын жолооч", "assets/logo/Duudlagiin jolooch@300x.png", '0', "driver"),
                btn("Дуудлагын засвар", "assets/logo/Duudlagiin zasvar@300x.png", '0', "service"),
                InkWell(
                  onTap: (){
                    _toMap();
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/logo/Map@300x.png"),
                        width: 100,
                      ),
                      Text("Газрын зураг", style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _scan();
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Map()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/logo/QR@300x.png"),
                        width: 100,
                      ),
                      Text("QR уншигч", style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Map()));
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/logo/bidnii tuhai@300x.png"),
                        width: 100,
                      ),
                      Text("Бидний тухай", style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
                //btn("QR уншигч", "assets/logo/QR@300x.png", '0', ''),
                //btn("Бидний тухай", "assets/logo/bidnii tuhai@300x.png", '0', ''),
              ],
            ),
          )
        ],
      )
    );
  }

  InkWell btn(String txt, String img, String chs, String table){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Choose(title: txt, value: chs, table: table,)));
      },
      child: Column(
        children: <Widget>[
          Image(
            image: AssetImage(img),
            width: 100,
          ),
          //SizedBox(height: _space,),
          Text(txt, style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
        ],
      ),
    );
  }

}