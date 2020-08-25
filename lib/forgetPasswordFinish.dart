import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Finish extends StatefulWidget{
  _Finish createState() => _Finish();
}
class _Finish extends State<Finish>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(60),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorLowBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: colorCyan, size: 80,),
                ),
                SizedBox(height: 50,),
                Text(
                  "Нууц үг шинэчлэгдлээ",
                  style: TextStyle(
                    color: colorCyan,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "Нууц үг амжилттай шинэчлэгдлээ. Шинэ нууц үгэрээ нэвтэрнэ үү.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: ButtonTheme(
                    height: 50,
                    minWidth: 240,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
                      },
                      color: colorCyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("Нэвтрэх", style: TextStyle(color: Colors.white, fontSize: 24),),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }

}