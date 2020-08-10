import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'User.dart';
import 'dashboard.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

String phone, sms, pss, ovog, ner, address, sex = "Эрэгтэй", date;

class SignUp extends StatefulWidget{
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp>{
  var _dura = Duration(milliseconds: 300), _curve = Curves.ease;
  int _count = 0;
  String verificationId;
  PageController _controller = PageController(
    initialPage: 0,
  );
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _senddata() async {
    print("$ovog, $ner, $phone, $pss, $address, $sex, $date");
    var url = "https://duline.mn/usr.php";
    var data = {
      'ovog' : ovog,
      'ner' : ner,
      'phone': phone,
      'pass': pss,
      'address' : address,
      'sex' : sex,
      'born' : date,
    };
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    if(message == "Data Successfully Submitted."){
      usr = User('None', ovog, ner, phone, address, date, sex, '0', '0', '0', '0', '0');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
    }else{
      _showDialog("Алдаа гарлаа.");
      _count--;
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
    var ph = {'phone': phone};
    var response = await http.post(url, body: json.encode(ph));
    var mss = json.decode(response.body);
    await pr.hide();
    if(mss == null){
      _controller.nextPage(duration: _dura, curve: _curve);
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
        phoneNumber: "+976" + phone,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifyFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve,
      );
    }else{
      _showDialog("Бүртгэлтэй утасны дугаар байна.");
      _count--;
    }
  }

  Future<void> _signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential)
        .then((user){
      _controller.nextPage(duration: _dura, curve: _curve);
    }).catchError((e){
      print(e);
      _showDialog("Код буруу байна.");
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: ButtonTheme(
        height: 60,
        minWidth: 260,
        child: RaisedButton(
          color: colorCyan,
          child: Text("Үргэлжлүүлэх", style: TextStyle(fontSize: 24, color: Colors.white),),
          onPressed: (){
            _count++;
            switch(_count){
              case 1:
                if(phone == null || phone.length > 8){
                  _showDialog("Утасны дугаар биш байна.");
                  _count--;
                }else _findPhone();
                break;
              case 2:
                _signIn(sms);
                break;
              case 3:
                if(pss == null || pss.length < 8) _showDialog("Нууц үг 8-аас бага оронтой байж болохгүй.");
                else _controller.nextPage(duration: _dura, curve: _curve);
                break;
              case 4:
                if(ovog == null || ner == null || date == null) _showDialog("Мэдээлэлийг дутуу бөгөлсөн байна.");
                else _senddata();
                break;
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          PageView(
            physics:new NeverScrollableScrollPhysics(),
            controller: _controller,
            children: <Widget>[
              PhoneNumber(),
              VerificationCode(),
              Password(),
              OtherReg(),
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
                  _controller.previousPage(duration: _dura, curve: _curve);
                  if(_controller.offset == 0){
                    Navigator.pop(context);
                  }else{
                    _count--;
                    print(_count);
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

}
class PhoneNumber extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "       Бүртгүүлэх",
          style: TextStyle(
            color: colorDarkBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30,),
        Container(
          //color: colorDarkBlue,
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
                  "Утасны дугаарт очсон баталгаажуулах код бүртгэл үргэлжлүүлэхэд ашиглагдана",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40,),
                Text(
                  "Утасны дугаар",
                  style: TextStyle(
                    color: colorCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40,),
                TextFormField(
                  onChanged: (value){
                    phone = value;
                  },
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Утасны дугаараа оруулна уу",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ) ,
                  ),
                ),
                SizedBox(height: 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    box(1),
                    box(0),
                    box(0),
                    box(0),
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
class VerificationCode extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "       Бүртгүүлэх",
          style: TextStyle(
            color: colorDarkBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30,),
        Container(
          //color: colorDarkBlue,
          decoration: BoxDecoration(
            color: colorDarkBlue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Баталгаажуулах код",
                  style: TextStyle(
                    color: colorCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40,),
                txtfield("SMS-ээр ирсэн код оруулна уу"),
                SizedBox(height: 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    box(0),
                    box(1),
                    box(0),
                    box(0),
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

class Password extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "       Бүртгүүлэх",
          style: TextStyle(
            color: colorDarkBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30,),
        Container(
          //color: colorDarkBlue,
          decoration: BoxDecoration(
              color: colorDarkBlue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Нууц үг",
                  style: TextStyle(
                    color: colorCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Нууц үг",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ) ,
                  ),
                  onChanged: (value){
                    pss = value;
                  },
                ),
                SizedBox(height: 80,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    box(0),
                    box(0),
                    box(1),
                    box(0),
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

class OtherReg extends StatefulWidget{
  _OtherReg createState() => _OtherReg();
}
class _OtherReg extends State<OtherReg> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "       Бүртгүүлэх",
          style: TextStyle(
            color: colorDarkBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30,),
        Container(
          decoration: BoxDecoration(
              color: colorDarkBlue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Хувийн мэдээлэл",
                    style: TextStyle(
                      color: colorCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  txtfield("Овог"),
                  txtfield("Нэр"),
                  txtfield("Гэрийн хаяг"),
                  SizedBox(height: 30,),
                  Text(
                    "Төрсөн өдөр",
                    style: TextStyle(
                      color: colorCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  FlatButton(
                    child: Text(date == null ? "YYYY-MM-DD" : date, style: TextStyle(color: Colors.white, fontSize: 16),),
                    onPressed: (){
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1940),
                          lastDate: DateTime.now()).then((value){
                        setState(() {
                          date = value.toString().substring(0, 10);
                        });
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Хуйс",
                    style: TextStyle(
                      color: colorCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white,
                        disabledColor: colorCyan
                    ),
                    child: Row(
                      children: <Widget>[
                        Radio(
                          value: "Эрэгтэй",
                          groupValue: sex,
                          onChanged: (String value){
                            setState(() {
                              sex = value;
                            });
                          },
                          activeColor: colorCyan,
                          autofocus: true,
                        ),
                        FlatButton(
                          child: Text("Эрэгтэй",style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              sex = "Эрэгтэй";
                            });
                          },
                        ),
                        SizedBox(width: 40,),
                        Radio(
                          value: "Эмэгтэй",
                          groupValue: sex,
                          onChanged: (String value){
                            setState(() {
                              sex = value;
                            });
                          },
                          activeColor: colorCyan,
                        ),
                        FlatButton(
                          child: Text("Эмэгтэй",style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            setState(() {
                              sex = "Эмэгтэй";
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  //txtfield("Эргтэй"),
                  SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      box(0),
                      box(0),
                      box(0),
                      box(1),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
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
        case "SMS-ээр ирсэн код оруулна уу":
          sms = value;
          break;
        case "Овог":
          ovog = value;
          break;
        case "Нэр":
          ner = value;
          break;
        case "Гэрийн хаяг":
          address = value;
          break;
        case "Нууц үг":
          pss = value;
          break;
        default :
          break;
      }
    },
  );
}
Row box(int value){
  double _boxSize = 7, _spaceSize = 5;
  if(value == 0){
    return Row(
      children: <Widget>[
        Container(
          height: _boxSize,
          width: _boxSize,
          color: Colors.white,
        ),
        SizedBox(width: _spaceSize,),
      ],
    );
  }else{
    return Row(
      children: <Widget>[
        Container(
          height: _boxSize,
          width: _boxSize,
          color: colorCyan,
        ),
        SizedBox(width: _spaceSize,),
      ],
    );
  }
}