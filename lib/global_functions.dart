import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget propic(String bs64){
  var bytes = base64.decode(bs64);
  return Image.memory(bytes);
}

