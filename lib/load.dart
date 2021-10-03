import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wardus/home.dart';
import 'package:wardus/model.dart';
import 'package:wardus/start.dart';
import 'package:wardus/widgets/ftext.dart';

// Globals
import 'globals.dart' as gl;

class Load extends StatefulWidget {
  WModel model;
  Load(this.model);
  @override
  LoadState createState() {
    model.init();
    return LoadState();
  }
}

class LoadState extends State<Load> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ftext("Cargando...", 20.0, Colors.white, FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Get.off(Home());
            },
            child: ftext("HERE", 30.0, Colors.white, FontWeight.bold),
          )
        ],
      ),
    );
  }
}
