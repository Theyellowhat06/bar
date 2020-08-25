import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'notif.dart';
import 'profile.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateInfo extends StatefulWidget{
  final String title, value, code, phone;
  final IconData icon;

  const UpdateInfo({Key key, this.title, this.value, this.icon, this.code, this.phone}) : super(key: key);
  _UpdateInfo createState() => _UpdateInfo();

}

class _UpdateInfo extends State<UpdateInfo>{
  String _value, verificationId;

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
    String col;
    switch (widget.title){
      case "Төрсөн өдөр":
        col = "born";
        break;
      case "Утасны дугуур":
        col = "phone";
        break;
      case "Хаяг":
        col = "address";
        break;
      case "Дансны мэдээлэл":
        col = "bank";
        break;
    }
    var url = "https://duline.mn/update.php";
    var data = {
      'id' : usr.id,
      'col' : col,
      'value' : _value,
      'usr': 'uyf017',
      'pss': 'g6c51',
    };
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    await pr.hide();
    if(message == 'Update Successfully.'){
      usr.update(_value, widget.title);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
    }else{
      _showDialog("Алдаа гарлаа.");
    }
  }
  Future _findPhone() async {
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
    var url = "https://duline.mn/usr_control.php";
    var ph = {'phone': _value};
    var response = await http.post(url, body: json.encode(ph));
    var mss = json.decode(response.body);
    await pr.hide();
    print(mss);
    if(mss == null){
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
        this.verificationId = verId;
      };
      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
        this.verificationId = verId;
      };
      final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth){
        print('verified');
      };
      final PhoneVerificationFailed verifyFailed = (AuthException e) {
        print('${e.message}');
      };
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+976" + _value,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifyFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateInfo(title: "Баталгажуулах код", code: verificationId, icon: Icons.mail, phone: _value,)));
    }else{
      _showDialog("Бүртгэлгүй утасны дугаар байна.");
    }
  }

  Future<void> _signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: widget.code,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential)
        .then((user){
      Navigator.pop(context);
      _value = widget.phone;
      _update();
    }).catchError((e){
      print(e);
      _showDialog("Код буруу байна.");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Notif()));
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.person_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorCyan,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 50,),
              ),
              SizedBox(height: 40,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                    color: colorLowBlue,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    newOne(),
                    /*TextField(
                      onChanged: (value){
                        _value = value;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: widget.value,
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ButtonTheme(
                height: 50,
                minWidth: 240,
                child: RaisedButton(
                  onPressed: (){
                    if(widget.title == "Утасны дугуур"){
                      _findPhone();
                    }else if(widget.title == "Баталгажуулах код"){
                      _signIn(_value);
                    }
                    else{
                      _update();
                    }
                  },
                  color: colorCyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text("Солих", style: TextStyle(color: Colors.white, fontSize: 24),),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  Widget newOne(){
    if(widget.title == "Төрсөн өдөр"){
      return Center(
        child: FlatButton(
          child: Text(_value == null ? "YYYY-MM-DD" : _value, style: TextStyle(color: Colors.white, fontSize: 16),),
          onPressed: (){
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1940),
                lastDate: DateTime.now()).then((value){
              setState(() {
                _value = value.toString().substring(0, 10);
              });
            });
          },
        ),
      );
    }else if(widget.title == "Утасны дугуур"){
      return TextField(
        onChanged: (value){
          _value = value;
        },
        maxLength: 8,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.value,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      );
    }else{
      return TextField(
        onChanged: (value){
          _value = value;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.value,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
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