import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget{
  final double lat, lng;

  const Map({Key key, this.lat, this.lng}) : super(key: key);
  _Map createState() => _Map();
}
class _Map extends State<Map>{
  static double _lat = 47.919345, _lng = 106.917544;
  GoogleMapController _controller;
  BitmapDescriptor userIcon;
  Set<Marker> markers;
  var currentLocation = LocationData;

  var location = new Location();
  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
    setState(() {
      _lat = widget.lat;
      _lng = widget.lng;
    });
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(_lat, _lng),
    zoom: 16,
  );

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
      body: GoogleMap(
          markers: markers,
          //mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              markers.add(Marker(markerId: MarkerId('user'), icon: userIcon, position: LatLng(widget.lat, widget.lng)));
            });
          },
      ),
    );
  }

}