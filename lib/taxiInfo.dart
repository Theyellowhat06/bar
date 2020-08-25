import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'notif.dart';
import 'profile.dart';
import 'listView.dart';
import 'map.dart';

import 'package:flutter_svg/flutter_svg.dart';

class TaxiInfo extends StatefulWidget{
  final int index;

  const TaxiInfo({Key key, this.index}) : super(key: key);
  _WorkerInfo createState() => _WorkerInfo();
}

class _WorkerInfo extends State<TaxiInfo>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: ButtonTheme(
          height: 50,
          minWidth: 240,
          child: RaisedButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: colorCyan,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
            ),
            child: Text("Ажилд авах", style: TextStyle(color: Colors.white, fontSize: 24),),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text("Дэлгэрэнгү мэдээлэл", style: TextStyle(color: Colors.white),),
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
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorLowBlue,
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    //padding: EdgeInsets.all(30),
                    children: <Widget>[
                      Center(
                        child: ClipOval(
                            child: new SizedBox(
                              height: 140,
                              width: 140,
                              child: _pic(workers[widget.index].usrId),
                            )
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("ID: ${workers[widget.index].usrId}", style: TextStyle(color: Colors.white),),
                          SizedBox(width: 20,),
                          SvgPicture.asset("assets/svg/star.svg", width: 20, color: colorStar,),
                          SizedBox(width: 5,),
                          Text(workers[widget.index].rate, style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Text("${workers[widget.index].ovog} ${workers[widget.index].ner}", style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
                      SizedBox(height: 20,),
                      _info(workers[widget.index].bornDate, Icons.date_range),
                      _info(workers[widget.index].phone, Icons.phone),
                      _info(workers[widget.index].sex, Icons.accessibility_new),
                      _info(workers[widget.index].address, Icons.location_on),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 80),
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorLowBlue,
                ),
                child: Map(lat: workers[widget.index].lat, lng: workers[widget.index].lng),
              ),
            )
          ],
        )
    );
  }
  ListTile _info(String txt, IconData icon){
    return ListTile(
      leading: Icon(icon, color: colorCyan,),
      title: Text(txt, style: TextStyle(color: Colors.white),),
    );
  }
  FadeInImage _pic(String id){
    if(id != '') return FadeInImage(
        placeholder: AssetImage("assets/account.png"),
        image: NetworkImage("https://duline.mn/images/" + id + ".jpg?=" + DateTime.now().toString())
    );
  }

}