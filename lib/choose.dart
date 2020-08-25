import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'listView.dart';
import 'deliverMap.dart';

import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:numberpicker/numberpicker.dart';

PageController controller = PageController(
  initialPage: 0,
);
var dura = Duration(milliseconds: 300), curve = Curves.ease;
bool child = false, old = false , hb = false;
String edu, skill, dsc;
class Choose extends StatefulWidget{
  final String title, value, table;

  const Choose({Key key, this.title, this.value, this.table}) : super(key: key);
  _Choose createState() => _Choose();
}

class _Choose extends State<Choose>{
  Location location = new Location();
  int chs, handleChange = 1;

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future _pushData(String table, String ovog, String ner, String phone,
      String address, String born, String sex, String rate, String review,
      String edu, String skill, String dsc, String id) async {
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
    if(widget.value == '1'){
      dsc = '';
      if(child) dsc = dsc + "Хүүхэд хүргэх";
      if(old) dsc = dsc + "%Настай хүн хүргэх";
      if(hb) dsc = dsc + "%Хөгжилийн бэрхшээлтэй хүн хүргэх";
    }
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
      'edu' : edu,
      'skill' : skill,
      'dsc' : dsc,
      'usr_id' : id,
      'lat' : _locationResult.latitude.toString(),
      'lng' : _locationResult.longitude.toString(),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 40,),
              Image(
                image: AssetImage("assets/logo_grey.png"),
              ),
            ],
          ),
          //Image.asset("assets/logo_grey.png", width: MediaQuery.of(context).size.width,),
          PageView(
            physics:new NeverScrollableScrollPhysics(),
            controller: controller,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: colorDarkBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: colorCyan,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 80,),
                          Center(
                            child: ButtonTheme(
                              height: 50,
                              minWidth: 240,
                              child: RaisedButton(
                                onPressed: (){
                                  if(widget.title == "Хүргэлтийн үйлчилгээ" || widget.table == "child"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Map(table: widget.table,)));
                                  }else if(widget.table == "child_care" || widget.table == "part_time"){
                                    chs = 1;
                                    controller.nextPage(duration: dura, curve: curve);
                                  }else{
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => ListV(title: widget.title, table: widget.table,)));
                                  }
                                },
                                color: colorCyan,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text("Ажил олгогч", style: TextStyle(color: Colors.white, fontSize: 24),),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Center(
                            child: ButtonTheme(
                              height: 50,
                              minWidth: 240,
                              child: RaisedButton(
                                onPressed: (){
                                  setState(() {
                                    chs = 0;
                                  });
                                  controller.nextPage(duration: dura, curve: curve);
                                  //Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
                                },
                                color: colorCyan,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text("Ажил горьлогч", style: TextStyle(color: Colors.white, fontSize: 24),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              secoundPage(chs),
            ],
          ),
          Positioned(
              left: 40,
              top: 40,
              child: ButtonTheme(
                minWidth: 50,
                height: 50,
                child: RaisedButton(
                  onPressed: (){
                    if(controller.offset == 0){
                      Navigator.pop(context);
                    }else{
                      controller.previousPage(duration: dura, curve: curve);
                    }
                  },
                  color: colorCyan,
                  child: Icon( Icons.arrow_back_ios, color: Colors.white,),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
              )
          )
        ],
      ),
    );
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

  Column _inputList(String chs){
    if(chs == "child"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: ListTile(
              leading: Checkbox(
                value: child,
                onChanged: (bool value) {
                  setState(() {
                    child = value;
                  });
                },
              ),
              title: Text("Хүүхэд хүргэх", style: TextStyle(color: Colors.white)),
            ),
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: ListTile(
              leading: Checkbox(
                value: old,
                checkColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    old = value;
                  });
                },
              ),
              title: Text("Настай хүн хүргэх", style: TextStyle(color: Colors.white),),
            ),
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: ListTile(
              leading: Checkbox(
                value: hb,
                checkColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    hb = value;
                  });
                },
              ),
              title: Text("Хөгжилийн бэрхшээлтэй хүн хүргэх", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          txt("Нэмэлт мэдээлэл"),
          TextFormField(
            onChanged: (value){
              dsc = value;
            },
            style: TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Нэмэлт мэдээлэл",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ) ,
            ),
          ),
        ],
      );
    }
  }

  Column secoundPage(int _chs){
    if(_chs == 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: colorDarkBlue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
            ),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ажил горьлогчийн \nнэмэлт мэдээлэл",
                    style: TextStyle(
                      color: colorCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40,),
                  txt("Боловсрол"),
                  txtfield("Боловсрол"),
                  SizedBox(height: 20,),
                  txt("Таны давуу тал"),
                  txtfield("Таны давуу тал"),
                  SizedBox(height: 20,),
                  _inputList(widget.table),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        height: 50,
                        minWidth: 240,
                        child: RaisedButton(
                          onPressed: (){
                            _pushData(widget.table, usr.ovog, usr.ner, usr.phone, usr.address, usr.bornDate, usr.sex, usr.rate, usr.review, edu, skill, dsc, usr.id);
                          },
                          color: colorCyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("Үргэлжлүүлэх", style: TextStyle(color: Colors.white, fontSize: 24),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: colorDarkBlue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
            ),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ажилын цаг",
                    style: TextStyle(
                      color: colorCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40,),
                  Center(
                    child: Theme(
                      data: ThemeData(
                          textTheme: TextTheme(
                              bodyText2: TextStyle(color: Colors.white)
                          )
                      ),
                      child: new NumberPicker.integer(
                          initialValue: handleChange,
                          minValue: 1,
                          maxValue: 24,
                          onChanged: (value) => setState(() => handleChange = value)),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonTheme(
                        height: 50,
                        minWidth: 240,
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ListV(title: widget.title, table: widget.table,)));
                            //_pushData(widget.table, usr.ovog, usr.ner, usr.phone, usr.address, usr.bornDate, usr.sex, usr.rate, usr.review, edu, skill, dsc, usr.id);
                          },
                          color: colorCyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("Үргэлжлүүлэх", style: TextStyle(color: Colors.white, fontSize: 24),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

}

Text txt(String str){
  return Text(
    str,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    ),
  );
}
TextFormField txtfield(String hint){
  return TextFormField(
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ) ,
    ),
    onChanged: (value){
      switch(hint){
        case "Боловсрол":
          edu = value;
          break;
        case "Таны давуу тал":
          skill = value;
          break;
        case "Нэмэлт мэдээлэл":
          dsc = value;
          break;
        default :
          break;
      }
    },
  );
}