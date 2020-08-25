import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

import 'package:video_player/video_player.dart';

class Splash extends StatefulWidget{
  _Splash createState()=> _Splash();
}

class _Splash extends State<Splash>{
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  void initState(){
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: Colors.black,
      child: VideoPlayer(_controller)
    );
  }
}