import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'profile.dart';
import 'notif.dart';

class Dashboard extends StatefulWidget{
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{
  double _space = 15;

  @override
  Widget build(BuildContext context) {
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
              childAspectRatio: 0.75,
              children: <Widget>[
                btn("Хүргэлтийн үйлчилгээ"),
                btn("Цагийн ажил"),
                btn("Такси дуудлага"),
                btn("Хүүхэд хүргэлт"),
                btn("Хүүхэд харах"),
                btn("Дуудлагын жолооч"),
                btn("Дуудлагын засвар"),
                btn("Газрын зураг"),
                btn("QR уншигч"),
                btn("Бидний тухай"),
              ],
            ),
          )
        ],
      )
    );
  }

  InkWell btn(String txt){
    return InkWell(
      onTap: (){

      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: colorLowBlue,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: _space,),
          Text(txt, style: TextStyle(color: Colors.white,), textAlign: TextAlign.center,),
        ],
      ),
    );
  }

}