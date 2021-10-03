import 'dart:ui';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

// Assets
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wardus/home.dart';

// Globals
import 'globals.dart' as gl;
import 'package:wardus/main.dart' as main;
import 'package:wardus/widgets/ftext.dart';

class Helped extends StatefulWidget {
  @override
  HelpedState createState() {
    print("SUPSUP");
    main.model.getHelp();
    return HelpedState();
  }
}

class HelpedState extends State<Helped> {
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
    margintop = gl.height * 0.02;
  }

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.bottom;
    return WillPopScope(
      child: Scaffold(
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
              margintop = pos * gl.height * 0.06;
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
                    color: gl.pC,
                    margin: EdgeInsets.only(
                      top: gl.height * 0.026,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: gl.width,
                              child: Center(
                                child: ftext("Ayuda en camino", 23.0,
                                    Colors.white, FontWeight.w800),
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
                              child: ftext("5 mins", 18.0, Colors.white,
                                  FontWeight.w400),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: pow(margintop, 0.7) * 1.00,
                              ),
                              width: gl.width * 0.5,
                              padding: EdgeInsets.only(right: gl.width * 0.1),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ftext("2 personas", 20.0, Colors.white,
                                    FontWeight.w400),
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
              Container(
                margin: EdgeInsets.only(top: gl.height * 0.03),
                width: gl.width * 0.8,
                height: gl.height * 0.35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.5),
                  borderRadius:
                      BorderRadius.circular((gl.height / gl.width) * 3),
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        width: gl.width * 0.7,
                        height: gl.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: gl.width * 0.5,
                              child: ftext("Adam El Messaoudi", 20.0,
                                  Colors.white, FontWeight.w400),
                            ),
                            Container(
                              width: gl.width * 0.2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("720m", 20.0, Colors.white,
                                          FontWeight.w400),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("2min", 20.0, Colors.white,
                                          FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        width: gl.width * 0.7,
                        height: gl.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: gl.width * 0.5,
                              child: ftext("Franchesco Franco", 20.0,
                                  Colors.white, FontWeight.w400),
                            ),
                            Container(
                              width: gl.width * 0.2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("1936m", 20.0, Colors.white,
                                          FontWeight.w400),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("14min", 20.0, Colors.white,
                                          FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ANCHOR Cancel BUTTON

              GestureDetector(
                onTap: () {
                  cancelar();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: (gl.height * 0.03),
                  ),
                  width: gl.width * 0.8,
                  height: gl.height * 0.06,
                  decoration: BoxDecoration(
                    color: gl.rC,
                    borderRadius:
                        BorderRadius.circular((gl.height / gl.width) * 3),
                  ),
                  child: Center(
                      child: ftext(
                          "Finalizar", 20.0, Colors.white, FontWeight.w700)),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                height: gl.height,
                width: gl.width,
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  //rotateGesturesEnabled: false,
                  compassEnabled: true,
                  //mapType: MapType.terrain,
                  //myLocationEnabled: true,
                  initialCameraPosition: _initial,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  },
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        top: (gl.height * 0.03),
                        left: (gl.width * 0.03),
                      ),
                      width: gl.width * 0.25,
                      height: gl.height * 0.06,
                      decoration: BoxDecoration(
                        color: gl.pC,
                        borderRadius:
                            BorderRadius.circular((gl.height / gl.width) * 3),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: gl.width * 30.0 / 500,
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: gl.width * 0.13),
                              child: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.red,
                                size: gl.width * 22.0 / 500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        top: (gl.height * 0.03),
                        left: (gl.width * 0.03),
                      ),
                      width: gl.width * 0.38,
                      height: gl.height * 0.06,
                      decoration: BoxDecoration(
                        color: gl.sC,
                        borderRadius:
                            BorderRadius.circular((gl.height / gl.width) * 3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.white,
                            size: gl.width * 30.0 / 500,
                          ),
                          Container(width: gl.width * 0.04),
                          ftext("112", 20.0, Colors.white, FontWeight.w700)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        top: (gl.height * 0.03),
                        left: (gl.width * 0.03),
                      ),
                      width: gl.width * 0.25,
                      height: gl.height * 0.06,
                      decoration: BoxDecoration(
                        color: gl.pC,
                        borderRadius:
                            BorderRadius.circular((gl.height / gl.width) * 3),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                              size: gl.width * 30.0 / 500,
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(right: gl.width * 0.13),
                              child: Icon(
                                Icons.fiber_manual_record,
                                color: Colors.red,
                                size: gl.width * 22.0 / 500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        cancelar();
        return Future.value(false);
      },
    );
  }

  void cancelar() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Finalizar alerta?'),
        content: const Text('Si clica finalizar, se cancelara la alerta.'),
        elevation: 20.0,
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => main.model.cancelgetHelp(),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }
}
