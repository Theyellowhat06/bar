import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'main.dart';
import 'listView.dart';
import 'notif.dart';
import 'profile.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:location/location.dart';

int count = 0;
var userloc, boxloc;
class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapSampleState();
}

class MapSampleState extends State<Map> {
  BitmapDescriptor userIcon;
  Set<Marker> markers;
  Location location = new Location();
  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
  }

  Future _pushData(String table, String ovog, String ner, String phone,
      String address, String born, String sex, String rate, String review, String id) async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
        message: 'Түр хүлээн үү...',
        borderRadius: 10.0,
        backgroundColor: colorDarkBlue,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
    LocationData _locationResult = await location.getLocation();
    var url = "https://duline.mn/deletepost.php";
    var data = {
      'id' : usr.id,
      'table' : table,
      'usr': 'uyf017',
      'pss': 'g6c51',
    };
    await http.post(url, body: json.encode(data));
    url = "https://duline.mn/deliver.php";
    data = {
      'table' : table,
      'ovog' : ovog,
      'ner' : ner,
      'phone' : phone,
      'address' : address,
      'born' : born,
      'sex' : sex,
      'rate' : rate,
      'review' : review,
      'usr_id' : id,
      'lat' : userloc.latitude.toString(),
      'lng' : userloc.longitude.toString(),
      'usr': 'uyf017',
      'pss': 'g6c51',
    };
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    print(message);
    await pr.hide();
    Navigator.pop(context);
    Navigator.pop(context);
    _showDialog("Таны мэдээлэл нэмэгдлээ");
  }

  createMarker(context) {
    if (userIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/logo/marker.png')
          .then((icon) {
        setState(() {
          userIcon = icon;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    createMarker(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Байршил", style: TextStyle(color: Colors.white),),
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
      floatingActionButton: finish_button(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        markers: markers,
        zoomControlsEnabled: false,
        onTap: (pos) {
            setState(() {
              markers.add(Marker(markerId: MarkerId('user'), icon: userIcon, position: pos));
            });
            count++;
            userloc = pos;
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            if(userloc != null){
              markers.add(Marker(markerId: MarkerId('user'), icon: userIcon, position: userloc));
            }
          });
        },
        initialCameraPosition: CameraPosition(target: LatLng(47.920432, 106.917295), zoom: 14),
      ),
    );
  }
  Widget finish_button(){
    if(count == 0){
      return ButtonTheme(
        height: 50,
        minWidth: 240,
        child: RaisedButton(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text("Ажил олгох", style: TextStyle(color: Colors.white, fontSize: 24),),
        ),
      );
    }
    else{
      return ButtonTheme(
        height: 50,
        minWidth: 240,
        child: RaisedButton(
          onPressed: (){
            _pushData("taxi", usr.ovog, usr.ner, usr.phone, usr.address, usr.bornDate, usr.sex, usr.rate, usr.review, usr.id);
            //Navigator.push(context,MaterialPageRoute(builder: (context) => ListV(title: "Хүргэлтийн үйлчилгээ", table: "deliver1", lat: boxloc.latitude, lng: boxloc.longitude,)));
          },
          color: colorCyan,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text("Ажил олгох", style: TextStyle(color: Colors.white, fontSize: 24),),
        ),
      );
    }
  }
  _showDialog(String txt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(txt, style: TextStyle(color: Colors.white),),
          backgroundColor: colorDarkBlue,
          actions: <Widget>[
            FlatButton(
              child: new Text("Хаах"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}