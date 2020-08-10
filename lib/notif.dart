import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'profile.dart';

class Notif extends StatefulWidget{
  _Notif createState()=> _Notif();
}

class _Notif extends State<Notif>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Мэдэгдэл", style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
    );
  }

}