import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'signUp.dart';
import 'dashboard.dart';
import 'User.dart';
import 'profile.dart';
import 'forgetPassword.dart';
import 'forgetPasswordFinish.dart';
import 'camera.dart';
import 'splash.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:flushbar/flushbar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0), // status bar color
    statusBarIconBrightness: Brightness.light,
    //systemNavigationBarColor: Colors.black,
  ));
  runApp(MyApp());
}

const Color colorDarkBlue = Color(0xff111515), colorLowBlue = Color(0xff141E28), colorCyan = Color(0xff21C3EC), colorStar = Color(0xffffde3b);
User usr;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorCyan,
        accentColor: colorCyan,
        scaffoldBackgroundColor: colorDarkBlue,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        fontFamily: "Roboto",
        textTheme: TextTheme(

        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: Profile(),
      home: Splash(),
      //home: Finish(),
      //home: Dashboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Location location = new Location();
  String _phone, _pss;
  bool _canLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var _msg = message["notification"];
        //notifGetter();
        _flashbar(_msg["title"], _msg["body"], false);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
  void _flashbar(String title, String body, bool withButton){
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration:  Duration(seconds: 4),
      backgroundColor: Colors.white,

      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Column(
        children: <Widget>[
          Text(
            body,
            style: TextStyle(fontFamily: "ShadowsIntoLightTwo"),
          ),
          if(withButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  child: Text("Хүлээн авах", style: TextStyle(color: Colors.green),),
                  onPressed: (){
                    //deleteNotif(1, notifs[notifs.length - 1].id, notifs[notifs.length - 1].post_id, notifs.length - 1);
                    //sendnotif(notifs[notifs.length - 1].req_id);
                  },
                ),
                SizedBox(width: 100,),
                MaterialButton(
                  child: Text("Татгалзах", style: TextStyle(color: Colors.red),),
                  onPressed: (){
                    //deleteNotif(0, notifs[notifs.length - 1].id, notifs[notifs.length - 1].post_id, notifs.length - 1);
                  },
                )
              ],
            ),
        ],
      ),
      boxShadows: [BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    )..show(context);
  }
  Future _updateinfo() async{
    LocationData _locationResult = await location.getLocation();
    var url = "https://duline.mn/updatemypost.php";
    var data = {
      'usr': 'uyf017',
      'pss': 'g6c51',
      'id' : usr.id,
      'lat' : _locationResult.latitude.toString(),
      'lng' : _locationResult.longitude.toString(),
      'phone' : usr.phone,
      'address' : usr.address,
      'born' : usr.bornDate,
      'rate' : usr.rate,
    };
    await http.post(url, body: json.encode(data));
  }
  Future<bool> userLogin() async{
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
    var url = 'https://duline.mn/usrloggin.php';
    var data = {'phone': _phone, 'pass' : _pss};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    if(message == 'Login Matched')
    {
      url = "https://duline.mn/usr_control.php";
      var ph = {'phone': _phone};
      response = await http.post(url, body: json.encode(ph));
      var jsonData = json.decode(response.body);
      var u = jsonData;
      usr = User(u["id"].toString(), u["ovog"], u["ner"], u["phone"], u["address"], u["born"], u["sex"], u["amount"], u["bank"], u["rate"], u["review"], u["id2"]);
      var res = await http.get(
        "https://duline.mn/images/${usr.id}.jpg?=" + DateTime.now().toString(),
      );
      if (mounted) {
        setState(() {
          bs64 = base64.encode(res.bodyBytes);
          print(bs64);
        });
      }
      print(jsonData);
      await pr.hide();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard())
      );
      _updateinfo();
    }else{
      await pr.hide();
      _showDialog(message);
    }
  }
  Future _fingerprint() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate =
    await localAuth.authenticateWithBiometrics(
        localizedReason: 'Хурууны хээгээ уншуулна уу.');
    print(didAuthenticate);
    if(didAuthenticate){
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
      await _get();
      if(_canLogin){
        var url = 'https://duline.mn/usrloggin.php';
        var data = {'phone': _phone, 'pass' : _pss};
        var response = await http.post(url, body: json.encode(data));
        var message = jsonDecode(response.body);

        if(message == 'Login Matched')
        {
          await _save(_phone);
        }else{
          await _read();
        }
        url = "https://duline.mn/usr_control.php";
        var ph = {'phone': _phone};
        response = await http.post(url, body: json.encode(ph));
        var jsonData = json.decode(response.body);
        var u = jsonData;
        usr = User(u["id"].toString(), u["ovog"], u["ner"], u["phone"], u["address"], u["born"], u["sex"], u["amount"], u["bank"], u["rate"], u["review"], u["id2"]);
        var res = await http.get(
          "https://duline.mn/images/${usr.id}.jpg?=" + DateTime.now().toString(),
        );
        if (mounted) {
          setState(() {
            bs64 = base64.encode(res.bodyBytes);
            print(bs64);
          });
        }
        await pr.hide();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard())
        );
        _updateinfo();
      }else{
        var url = 'https://duline.mn/usrloggin.php';
        var data = {'phone': _phone, 'pass' : _pss};
        var response = await http.post(url, body: json.encode(data));
        var message = jsonDecode(response.body);

        if(message == 'Login Matched')
        {
          url = "https://duline.mn/usr_control.php";
          var ph = {'phone': _phone};
          response = await http.post(url, body: json.encode(ph));
          var jsonData = json.decode(response.body);
          var u = jsonData;
          usr = User(u["id"].toString(), u["ovog"], u["ner"], u["phone"], u["address"], u["born"], u["sex"], u["amount"], u["bank"], u["rate"], u["review"], u["id2"]);
          var res = await http.get(
            "https://duline.mn/images/${usr.id}.jpg?=" + DateTime.now().toString(),
          );
          if (mounted) {
            setState(() {
              bs64 = base64.encode(res.bodyBytes);
              print(bs64);
            });
          }
          await _save(_phone);
          await pr.hide();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard())
          );
          _updateinfo();
        }else{
          await pr.hide();
          _showDialog("Бүртгэлтэй хэргэлэч олдсонгүй");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 40,
                  child: Center(
                    child: Image(
                      width: 150,
                      image: AssetImage("assets/logo2@300x.png"),
                    )
                  ),
                ),
                TextFormField(
                  onChanged: (value){
                    setState(() {
                      _phone = value.toString();
                    });
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorDarkBlue),
                  decoration: InputDecoration(
                      hintText: "Утасны дугаар",
                      hintStyle: TextStyle(color: colorDarkBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorDarkBlue),
                      ),
                  ),
                ),
                SizedBox(height: 30,),
                TextField(
                  onChanged: (value){
                    setState(() {
                      _pss = value.toString();
                    });
                  },
                  obscureText: true,
                  style: TextStyle(color: colorDarkBlue),
                  decoration: InputDecoration(
                      hintText: "Нууц үг",
                      hintStyle: TextStyle(color: colorDarkBlue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorDarkBlue),
                      ),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                  },
                  child: Text("Нууц үгээ мартсан уу?", style: TextStyle(color: colorCyan),),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      height: 50,
                      minWidth: 200,
                      child: RaisedButton(
                        onPressed: (){
                          userLogin();
                        },
                        color: colorDarkBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("Нэвтрэх", style: TextStyle(color: Colors.white, fontSize: 24),),
                      ),
                    ),
                    SizedBox(width: 10,),
                    /*ButtonTheme(
                      height: 50,
                      minWidth: 50,
                      child: RaisedButton(
                        onPressed: (){
                          userLogin();
                        },
                        color: colorCyan,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Icon(Icons.fingerprint, color: colorDarkBlue, size: 30,),
                      ),
                    ),*/
                    InkWell(
                      onTap: (){
                        _fingerprint();
                        //_read();
                      },
                      child: Container(
                        height: 50,
                        width: 60,
                        child: Icon(Icons.fingerprint, color: Colors.white, size: 40,),
                        decoration: BoxDecoration(
                          color: colorDarkBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                  ],
                ),
                /*SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                ),*/
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CameraApp()));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text("Бүртгүүлэх", style: TextStyle(color: colorCyan),),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
  _get() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phone';
    if(prefs.getString(key) == null){
      _canLogin = false;
    }else{
      _canLogin = true;
    }
  }
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phone';
    final value = prefs.getString(key);
    print('read: $value');
    _phone = value;
  }

  _save(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phone';
    final value = phone;
    prefs.setString(key, value);
    print('saved $value');
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