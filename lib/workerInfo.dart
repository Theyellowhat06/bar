import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'notif.dart';
import 'profile.dart';
import 'listView.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WorkerInfo extends StatefulWidget{
  final int index;
  final String table;

  const WorkerInfo({Key key, this.index, this.table}) : super(key: key);
  _WorkerInfo createState() => _WorkerInfo();
}

class _WorkerInfo extends State<WorkerInfo>{
  Future sendnotif() async {
    var url = "https://duline.mn/notif_pusher.php";
    var data = {
      'ovog' : usr.ovog,
      'ner' : usr.ner,
      'id' : workers[widget.index].usrId,
    };
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    print(message);
    _update();
  }
  Future _update() async {
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
    var url = "https://duline.mn/changetype.php";
    var data = {
      'id' : usr.id,
      'table' : widget.table,
      'value' : '0',
      'usr': 'uyf017',
      'pss': 'g6c51',
    };
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    await pr.hide();
    if(message == 'Update Successfully.'){
    }else{
    }
  }
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
            sendnotif();
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorLowBlue,
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Боловсрол",
                      style: TextStyle(
                        color: colorCyan,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("  ${workers[widget.index].edu}", style: TextStyle(color: Colors.white),),
                    SizedBox(height: 20,),
                    Text(
                      "Давуу тал",
                      style: TextStyle(
                        color: colorCyan,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("  ${workers[widget.index].skill}", style: TextStyle(color: Colors.white),),
                    SizedBox(height: 20,),
                    Text(
                      "Нэмэлт мэдээлэл",
                      style: TextStyle(
                        color: colorCyan,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    widget.table == "child" ?
                    Column(
                      children: workers[widget.index].dsc.split("%").map((String txt) => ListTile(leading: Icon(Icons.check, color: colorCyan,), title: Text(txt, style: TextStyle(color: Colors.white)),)).toList(),
                    ):
                    //workers[widget.index].dsc.split("%").map((String txt) => Text(txt, style: TextStyle(color: Colors.white)),).toList() :
                    Text("  ${workers[widget.index].dsc}", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
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