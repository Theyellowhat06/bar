import 'dart:async';

import 'main.dart';
import 'listView.dart';
import 'notif.dart';
import 'profile.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
int count = 0;
var userloc, boxloc;
class Map extends StatefulWidget {
  final String table;

  const Map({Key key, this.table}) : super(key: key);
  @override
  State<Map> createState() => MapSampleState();
}

class MapSampleState extends State<Map> {
  BitmapDescriptor userIcon;
  BitmapDescriptor boxIcon;
  Set<Marker> markers;
  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
  }

  createMarker(context) {
    if (userIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/logo/ehleh.png')
          .then((icon) {
        setState(() {
          userIcon = icon;
        });
      });
    }
    if (boxIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/logo/hurgeh.png')
          .then((icon) {
        setState(() {
          boxIcon = icon;
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
        title: Text("Хүргэлтийн үйлчилгээ", style: TextStyle(color: Colors.white),),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ButtonTheme(
            height: 50,
            minWidth: 240,
            child: RaisedButton(
              onPressed: (){
                setState(() {
                  markers.remove(Marker(markerId: MarkerId('user'), icon: userIcon, position: userloc));
                  markers.remove(Marker(markerId: MarkerId('box'), icon: boxIcon, position: boxloc));
                  count = 0;
                });
              },
              color: colorCyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Text("Дахин байршуулах", style: TextStyle(color: Colors.white, fontSize: 24),),
            ),
          ),
          SizedBox(height: 10,),
          finish_button(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        markers: markers,
        zoomControlsEnabled: false,
        onTap: (pos) {
          //print(pos);
          if(count == 0){
            setState(() {
              markers.add(Marker(markerId: MarkerId('user'), icon: userIcon, position: pos));
            });
            count++;
            userloc = pos;
            print("User location:\n-Lat: " + userloc.latitude.toString() + "\n-Lng: " + userloc.longitude.toString());
          }else if(count == 1){
            setState(() {
              markers.add(Marker(markerId: MarkerId('box'), icon: boxIcon, position: pos));
            });
            count++;
            boxloc = pos;
            print("Box location:\n-Lat: " + boxloc.latitude.toString() + "\n-Lng: " + boxloc.longitude.toString());
          }
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            if(userloc != null && boxloc != null){
              markers.add(Marker(markerId: MarkerId('user'), icon: userIcon, position: userloc));
              markers.add(Marker(markerId: MarkerId('box'), icon: boxIcon, position: boxloc));
            }
          });
        },
        initialCameraPosition: CameraPosition(target: LatLng(47.920432, 106.917295), zoom: 14),
      ),
    );
  }
  Widget finish_button(){
    if(count <= 1){
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
            Navigator.push(context,MaterialPageRoute(builder: (context) => ListV(title: "Хүргэлтийн үйлчилгээ", table: widget.table, lat: boxloc.latitude, lng: boxloc.longitude,)));
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
}