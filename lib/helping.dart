import 'dart:ui';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

// Assets
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wardus/home.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wardus/widgets/ftext.dart';

// Globals
import 'globals.dart' as gl;

class Helping extends StatefulWidget {
  @override
  HelpingState createState() => HelpingState();
}

class HelpingState extends State<Helping> {
  Completer<GoogleMapController> _controller = Completer();

  PanelController _pcontroller = new PanelController();
  double margintop = 0;
  static final CameraPosition _initial = CameraPosition(
    target: LatLng(41.7333, 1.8333),
    zoom: 14.4746,
  );

  String _mapStyle = "";
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: SlidingUpPanel(
        color: gl.pC,
        controller: _pcontroller,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular((gl.height / gl.width) * 7),
          topRight: Radius.circular((gl.height / gl.width) * 7),
        ),
        onPanelSlide: (double pos) {
          setState(() {
            margintop = pos * gl.height * 0.08;
          });
        },
        panel: Column(
          children: [
            Container(
              width: gl.width,
              height: gl.height * 0.024,
              child: Center(
                child: Container(
                  width: gl.width * 0.5,
                  height: gl.height * 0.009,
                  margin: EdgeInsets.only(top: gl.height * 0.015),
                  decoration: BoxDecoration(
                    color: gl.tC,
                    borderRadius:
                        BorderRadius.circular((gl.height / gl.width) * 2),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: gl.height * 0.1,
                  child: Center(
                    child: ftext(
                        "Información", 27.0, Colors.white, FontWeight.bold),
                  ),
                ),
                Container(
                  color: gl.pC,
                  margin: EdgeInsets.only(
                    top: gl.height * 0.02 + margintop,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(left: gl.width * 0.1),
                            child: ftext(
                                "Manresa", 25.0, Colors.white, FontWeight.w800),
                          ),
                          Container(
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(right: gl.width * 0.1),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ftext(
                                  "520m", 20.0, Colors.white, FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: pow(margintop, 0.6) * 1.00 +
                                    gl.height * 0.01),
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(left: gl.width * 0.1),
                            child: ftext("C/ Cardenal Lluch", 18.0,
                                Colors.white, FontWeight.w400),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: pow(margintop, 0.7) * 1.00,
                            ),
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(right: gl.width * 0.1),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ftext(
                                  "6 min", 20.0, Colors.white, FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ANCHOR Name Row
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.05),
                  width: gl.width * 0.3,
                  padding: EdgeInsets.only(left: gl.width * 0.1),
                  child: ftext("Nombre:", 18.0, Colors.white, FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.05),
                  width: gl.width * 0.7,
                  padding: EdgeInsets.only(right: gl.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ftext("Adam El Messaoudi", 17.0, Colors.white,
                        FontWeight.w400),
                  ),
                ),
              ],
            ),
            // ANCHOR Time of Alert Row
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.5,
                  padding: EdgeInsets.only(left: gl.width * 0.1),
                  child: ftext(
                      "Hora de Alerta:", 18.0, Colors.white, FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.5,
                  padding: EdgeInsets.only(right: gl.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:
                        ftext("17:02.25", 17.0, Colors.white, FontWeight.w400),
                  ),
                ),
              ],
            ),
            // ANCHOR Last update Row
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.5,
                  padding: EdgeInsets.only(left: gl.width * 0.1),
                  child: ftext("Ultima actualización:", 18.0, Colors.white,
                      FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.5,
                  padding: EdgeInsets.only(right: gl.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:
                        ftext("17:02.20", 17.0, Colors.white, FontWeight.w400),
                  ),
                ),
              ],
            ),
            // ANCHOR Name Row
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.05),
                  width: gl.width * 0.7,
                  padding: EdgeInsets.only(left: gl.width * 0.1),
                  child: ftext(
                      "Voluntarios:", 18.0, Colors.white, FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.05),
                  width: gl.width * 0.3,
                  padding: EdgeInsets.only(right: gl.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ftext("2", 17.0, Colors.white, FontWeight.w400),
                  ),
                ),
              ],
            ),
            // ANCHOR Name Row
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.7,
                  padding: EdgeInsets.only(left: gl.width * 0.1),
                  child:
                      ftext("Emergencia:", 18.0, Colors.white, FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: gl.height * 0.02),
                  width: gl.width * 0.3,
                  padding: EdgeInsets.only(right: gl.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ftext("Media", 17.0, Colors.white, FontWeight.w400),
                  ),
                ),
              ],
            ),
            // ANCHOR Cancel BUTTON
            GestureDetector(
              onTap: () {
                //Get.to(Home());
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: (gl.width * 0.1),
                ),
                width: gl.width * 0.8,
                height: gl.height * 0.06,
                decoration: BoxDecoration(
                  color: gl.rC,
                  borderRadius:
                      BorderRadius.circular((gl.height / gl.width) * 3),
                ),
                child: Center(
                    child:
                        ftext("Cancelar", 20.0, Colors.white, FontWeight.w700)),
              ),
            ),
          ],
        ),
        body: Container(
          height: gl.height - gl.statusHeight,
          child: GoogleMap(
            zoomControlsEnabled: false,
            //rotateGesturesEnabled: false,
            compassEnabled: true,
            padding: EdgeInsets.only(
                bottom: 50, right: gl.width * 0.5, left: gl.width * 0.5),
            //mapType: MapType.terrain,
            myLocationEnabled: true,
            initialCameraPosition: _initial,
            onMapCreated: (GoogleMapController controller) {
              //_controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
          ),
        ),
      ),
    );
  }
}
