import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'Worker.dart';
import 'notif.dart';
import 'profile.dart';
import 'workerInfo.dart';
import 'global_functions.dart';
import 'taxiMap.dart';
import 'taxiInfo.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

List<Worker> workers = [];

class ListV extends StatefulWidget{
  final String table, title;
  final double lat, lng;

  const ListV({Key key, this.table, this.title, this.lat, this.lng}) : super(key: key);
  _ListView createState() => _ListView();
}

class _ListView extends State<ListV>{
  Location location = new Location();

// neeed lat long

  Future<List<Worker>> _pullData() async{
    LocationData _locationResult = await location.getLocation();
    workers = [];
    Worker _worker;
    int _dest;
    var url = "https://duline.mn/deliver_get_post.php";
    var data = {
      'table' : widget.table,
      'usr': 'uyf017',
      'pss': 'g6c51',
    };
    var response = await http.post(url, body: json.encode(data));
    var jsonData = jsonDecode(response.body);
    //print(jsonData);
    for(var w in jsonData){
      //;
      if(widget.title == "Хүргэлтийн үйлчилгээ"){
        _dest = calcDest(widget.lat, widget.lng, "" == w['lat'] ? 0 : double.parse(w['lat']), "" == w['lng'] ? 0 : double.parse(w['lng']));
      }else{
        _dest = calcDest(_locationResult.latitude, _locationResult.longitude, "" == w['lat'] ? 0 : double.parse(w['lat']), "" == w['lng'] ? 0 : double.parse(w['lng']));
      }
      _worker = Worker(w['ovog'], w['ner'], w['phone'], w['address'],
          w['born'], w['sex'], w['rate'], w['review'], w['edu'],
          w['skill'], w['dsc'], w['usr_id'], _dest, w['type']);
      if(widget.table == "taxi"){
        _worker.setLatLng("" == w['lat'] ? 0 : double.parse(w['lat']), "" == w['lng'] ? 0 : double.parse(w['lng']));
      }
      workers.add(_worker);
      print(_dest);
    }
    print("start sort");
    sortDest(workers);
    sortRate(workers);
    print("sort finished");
    return workers;
    //if(message == "Data Successfully Submitted.");
    //else return await Future<bool>.value(false);
    //Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: plusButton(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
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
      body: FutureBuilder(
        future: _pullData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null) {
              return LinearProgressIndicator(backgroundColor: Colors.white,);
            }else{
              return new ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    onTap: (){
                      if(widget.table == "taxi"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TaxiInfo(index: index,)));
                      }else Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerInfo(index: index, table: widget.table,)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                                child: Column(
                                  children: <Widget>[
                                    ClipOval(
                                        child: new SizedBox(
                                          height: 50,
                                          width: 50,
                                          //child: Image.network("https://duline.mn/images/small" + snapshot.data[snapshot.data.length - index - 1].image + "?=" + DateTime.now().toString()),
                                          child: _pic(snapshot.data[index].usrId),
                                        )
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset("assets/svg/star.svg", width: 15, color: colorStar,),
                                        SizedBox(width: 5,),
                                        Text(snapshot.data[index].rate, style: TextStyle(color: Colors.white),)
                                      ],
                                    )
                                  ],
                                )
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *0.58,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("${snapshot.data[index].ovog} ${snapshot.data[index].ner}", style: TextStyle(color: Colors.white, fontSize: 16),),
                                  SizedBox(height: 5,),
                                  new Text("Хүйс: ${snapshot.data[index].sex}\nТөрсөн өдөр: ${snapshot.data[index].bornDate}\nСүүлд нэвтэрсэн зай: ${snapshot.data[index].dest}КМ", style: TextStyle(color: Colors.white70),),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *0.04,
                              child: Center(
                                child: snapshot.data[index].type == '1' ? Icon(Icons.brightness_1, color: Colors.green, size: 12,) : Icon(Icons.brightness_1, color: Colors.red, size: 12,),
                                //child: new Text(type(snapshot.data[snapshot.data.length - index - 1].type), style: TextStyle(color: typeColor(snapshot.data[snapshot.data.length - index - 1].type), fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: colorCyan)
                          ),
                        ),
                      ),
                    ),
                  );
                }
              );
            }
        }
      ),
    );
  }
  FadeInImage _pic(String id){
    if(id != '') return FadeInImage(
      placeholder: AssetImage("assets/account.png"),
      image: NetworkImage("https://duline.mn/images/small" + id + ".jpg?=" + DateTime.now().toString())
    );
  }
  /*NetworkImage _pic(String id){
    if(id != "") return NetworkImage("https://duline.mn/images/small" + id + ".jpg?=" + DateTime.now().toString());
  }*/
  void sortDest(List<Worker> _workers){
    for(int i = 0; i < _workers.length; i++ ){
      for(int j = i; j < _workers.length; j++){
        if(_workers[i].dest > _workers[j].dest){
          Worker _temp = Worker("","","","","","","","","","","","",0,"",);
          _temp.update(_workers[i]);
          print(_temp.phone);
          //_workers.removeAt(i);
          //_workers.insert(i, _workers[j]);
          //_workers.removeAt(j);
          //_workers.insert(j, _temp);
          _workers[i].update(_workers[j]);
          _workers[j].update(_temp);
        }
      }
    }
  }
  void sortRate(List<Worker> _workers){
    for(int i = 0; i < _workers.length; i++ ){
      for(int j = i; j < _workers.length; j++){
        if(double.parse(_workers[i].rate) > double.parse(_workers[j].rate)){
          Worker _temp = Worker("","","","","","","","","","","","",0,"",);
          _temp.update(_workers[i]);
          _workers[i].update(_workers[j]);
          _workers[j].update(_temp);
        }
      }
    }
  }
  FloatingActionButton plusButton(){
    if(widget.title == "Такси дуудлага"){
      return FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Map()));
        },
        backgroundColor: colorCyan,
        child: Icon(Icons.add, color: Colors.white,),
      );
    }else{
      return null;
    }
  }
}