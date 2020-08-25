import 'dart:convert';

import 'main.dart';
import 'notif.dart';
import 'profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

QRuser qrusr;

class QRrate extends StatefulWidget{
  _QRrate createState() => _QRrate();
}

class _QRrate extends State<QRrate>{
  var _rate;

  Future updateRate() async {
    var url = "https://duline.mn/rate_update.php";
    var data = {'id': qrusr.id,
                'rate': _rate.toString(),
                'selfId': usr.id};
    var response = await http.post(url, body: json.encode(data));
    var jsonData = json.decode(response.body);
    if(jsonData == "Update Successfully."){
      Navigator.pop(
          context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Хэргэдэгчийн мэдээлэл", style: TextStyle(color: Colors.white),),
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
      floatingActionButton: ButtonTheme(
        height: 50,
        minWidth: 240,
        child: RaisedButton(
          onPressed: (){
            updateRate();
          },
          color: colorCyan,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          child: Text("Дуусгах", style: TextStyle(color: Colors.white, fontSize: 24),),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                              child: _pic(qrusr.id),
                            )
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("ID: ${qrusr.id}", style: TextStyle(color: Colors.white),),
                      SizedBox(height: 20,),
                      Center(
                        child: Text("${qrusr.ovog} ${qrusr.ner}", style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
                      SizedBox(height: 20,),
                      _info(qrusr.bornDate, Icons.date_range),
                      _info(qrusr.sex, Icons.accessibility_new),
                      SizedBox(height: 20,),
                      RatingBar(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset("assets/svg/star.svg", color: colorStar,),
                          empty: SvgPicture.asset("assets/svg/star.svg", color: Colors.grey,),
                        ),
                        /*itemBuilder: (context, _) => Icon(
                          SvgPicture.asset("assets/svg/star.svg"),
                          color: Colors.yellow,
                        ),*/
                        onRatingUpdate: (rating) {
                          print(rating);
                          _rate = rating;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
      ),

      /*body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/account_blue.png"),
                  height: 150,
                  width: 150,
                ),
                ClipOval(
                    child: new SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.network("https://duline.mn/images/" + qrusr.image + "?=" + DateTime.now().toString())
                    )
                ),
              ],
            ),
            SizedBox(height: 20,),
            new Text("${qrusr.ovog} ${qrusr.ner}", style: TextStyle(fontWeight: FontWeight.bold),),
            new Text("Нас: ${qrusr.age}"),
            new Text("Хүйс: ${qrusr.sex}"),
            new Text("Хэргэлэгчийн дугаар: ${qrusr.id}"),
            SizedBox(height: 40,),
            RatingBar(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                _rate = rating;
              },
            ),
            SizedBox(height: 40,),
            RaisedButton(
              onPressed: (){

              },
              child: Text("Дуусгах"),
            ),
          ],
        ),
      ),*/
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

class QRuser{
  final String id, ovog, ner, bornDate, sex;

  QRuser(this.id, this.ovog, this.ner, this.bornDate, this.sex);

}