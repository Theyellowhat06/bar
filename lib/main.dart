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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0), // status bar color
    statusBarIconBrightness: Brightness.light,
    //systemNavigationBarColor: Colors.black,
  ));
  runApp(MyApp());
}

const Color colorDarkBlue = Color(0xff111515), colorLowBlue = Color(0xff141E28) , colorCyan = Color(0xff21C3EC);
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
        textTheme: TextTheme(

        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: Profile(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _phone, _pss;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var _msg = message["notification"];
        //notifGetter();
        //if(_msg["title"] == "Таны хүсэлтийг хүлээн авлаа.") _flashbar(_msg["title"], _msg["body"], false);
        //else _flashbar(_msg["title"], _msg["body"], true);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future userLogin() async{
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
      print(u);
      /*id = u["id"].toString();
      ovog = u["ovog"];
      ner = u["ner"];
      phone = u["phone"];
      bank = u["bank"];
      type = u["type"];
      age = u["age"];
      sex = u["sex"];
      usr_id = u["id"].toString();
      image = usr_id + ".jpg";
      rate = u["rate"];
      working = u["working"];
      review = u["review"].toString();
      id2 = u["id2"];*/
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
    }else{
      await pr.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
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
      );}
  }
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }
  Future _fingerprint() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate =
    await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to show account balance');
    print(didAuthenticate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 40,
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 400,
                      color: colorCyan,
                    ),
                  ),
                ),
                TextFormField(
                  onChanged: (value){
                    setState(() {
                      _phone = value.toString();
                    });
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Утасны дугаар",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ) ,
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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Нууц үг",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
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
                      minWidth: 240,
                      child: RaisedButton(
                        onPressed: (){
                          userLogin();
                        },
                        color: colorCyan,
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
                      },
                      child: Container(
                        height: 50,
                        width: 60,
                        child: Icon(Icons.fingerprint, color: colorDarkBlue, size: 40,),
                        decoration: BoxDecoration(
                          color: colorCyan,
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
}