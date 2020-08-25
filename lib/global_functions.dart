import 'dart:convert';

import 'package:http/http.dart' as http;

import 'main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget propic(String bs64){
  var bytes = base64.decode(bs64);
  return Image.memory(bytes);
}

int calcDest(double curlat, double curlng, double lat, double lng){
  int latDest = (positiveResult(curlat, lat) * 100).toInt() + 1,
      lngDest = (positiveResult(curlng, lng) * 100).toInt() + 1;
  if(latDest > lngDest){
    return latDest;
  }else{
    return lngDest;
  }
}
double positiveResult(double a, double b){
  if(a > b){
    return a - b;
  }else{
    return b - a;
  }
}
void showDialgo(String txt, BuildContext context) {
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