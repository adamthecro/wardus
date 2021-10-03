import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wardus/helped.dart';
import 'package:wardus/helping.dart';
import 'package:wardus/model.dart';
import 'package:wardus/main.dart' as main;
import 'package:wardus/start.dart';

// Assets
import 'package:wardus/widgets/ftext.dart';

// Globals
import 'globals.dart' as gl;

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (!await main.model.googleSignIn.isSignedIn()) {
        Get.off(() => Start());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: gl.height * 0.28,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: gl.dC,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: gl.height * 0.02),
                      child: Container(
                        width: gl.height * 0.1,
                        height: gl.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(gl.height),
                          image: DecorationImage(
                              image: NetworkImage(
                                  main.model.user!.photoUrl.toString()),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Container(
                      height: gl.height * 0.02,
                    ),
                    ftext(main.model.user!.displayName.toString(), 19.0,
                        Colors.white, FontWeight.w600),
                    Container(
                      height: gl.height * 0.01,
                    ),
                    ftext(main.model.user!.email.toString(), 19.0, Colors.white,
                        FontWeight.w400),
                  ],
                ),
              ),
            ),
            ListTile(
              title: ftext("Perfil", 19.0, Colors.black, FontWeight.w600),
              onTap: () {},
            ),
            ListTile(
              title:
                  ftext("Configuración", 19.0, Colors.black, FontWeight.w600),
              onTap: () {},
            ),
            ListTile(
              title: ftext("Contactos", 19.0, Colors.black, FontWeight.w600),
              onTap: () {},
            ),
            ListTile(
              title: ftext("Historial", 19.0, Colors.black, FontWeight.w600),
              onTap: () {},
            ),
            ListTile(
              title: ftext("Información", 19.0, Colors.black, FontWeight.w600),
              onTap: () {},
            ),
            ListTile(
              title: ftext("Cerrar Sessión", 19.0, Colors.red, FontWeight.w600),
              onTap: () {
                main.model.googleSignIn.disconnect();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ANCHOR TOP MARGIN
          Container(
            height: gl.statusHeight,
            width: gl.width,
          ),
          // ANCHOR TOP MENU
          Container(
            width: gl.width,
            height: gl.height * 0.07,
            color: gl.pC,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                  child: Container(
                    width: gl.width * 0.15,
                    height: gl.height * 0.07,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.menu_rounded,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: gl.width * 0.7,
                  height: gl.height * 0.07,
                  child: Center(
                    child: ftext("WardUs", 22.0, Colors.white, FontWeight.w800),
                  ),
                ),
                Container(
                  width: gl.width * 0.15,
                  height: gl.height * 0.07,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                  ),
                )
              ],
            ),
          ),
          // ANCHOR TIMESTAMP
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: (gl.height * 0.08),
                  ),
                  child: Center(
                    child: ftext(
                        "Friday, 1 April", 20.0, Colors.white, FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: (gl.height * 0.01),
                  ),
                  child: Center(
                    child: ftext("17:20", 90.0, Colors.white, FontWeight.w700),
                  ),
                ),
                Container(
                  width: gl.width,
                  margin: EdgeInsets.only(
                    top: (gl.height * 0.01),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: (gl.width * 0.03),
                        ),
                        child: Icon(
                          Icons.location_on,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: (gl.width * 0.03),
                        ),
                        child: Icon(
                          Icons.lte_mobiledata,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // ANCHOR NOTIS AND LOCATIONS
          Container(
            /*margin: EdgeInsets.only(
              top: (gl.width * 0.13),
            ),*/
            width: gl.width * 0.8,
            height: gl.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((gl.height / gl.width) * 3),
            ),
            child: GestureDetector(
              onTap: () {
                Map<String, dynamic> data = {
                  "id": main.model.user?.id,
                  "gonnahelp": 875645548654,
                };
                /*main.model.socket.emitWithAck('wanna_help', data, ack: (back) {
                  print(back);
                  if (back["error"]) {
                    EasyLoading.showError(back["log"].toString(),
                        duration: Duration(seconds: 3));
                  } else if (back["log"] == "go on") {*/
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      main.model.globalTimer(Duration(seconds: 5));
                      gl.doing = double.parse("875645548654");
                      return Helping();
                    },
                  ),
                );
                /*
                  }
                });*/
              },
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: gl.height * 0.03),
                  decoration: BoxDecoration(
                    color: gl.tC,
                    borderRadius:
                        BorderRadius.circular((gl.height / gl.width) * 3),
                  ),
                  width: gl.width * 0.8,
                  height: gl.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(left: gl.width * 0.05),
                            child: ftext("Juan Inodoro", 18.0, Colors.white,
                                FontWeight.w700),
                          ),
                          Container(
                            width: gl.width * 0.3,
                            padding: EdgeInsets.only(right: gl.width * 0.1),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ftext("1000 m", 17.0, Colors.white,
                                  FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: gl.height * 0.01),
                            width: gl.width * 0.5,
                            padding: EdgeInsets.only(left: gl.width * 0.05),
                            child: ftext('2 voluntarios', 18.0, Colors.white,
                                FontWeight.w500),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: gl.height * 0.01),
                            width: gl.width * 0.3,
                            padding: EdgeInsets.only(right: gl.width * 0.1),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ftext(
                                  "Media", 17.0, Colors.white, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ), /*ScopedModelDescendant<WModel>(
              builder: (context, child, model) {
                return ListView.builder(
                  itemCount: model.needhelplist.length,
                  itemBuilder: (BuildContext context, int index) {
                    NeedHelpData dude = model.needhelplist[index];
                    String g_id = dude.id;
                    String name = dude.name;
                    double lat = dude.latitude;
                    double long = dude.longitude;
                    double lat2 = 1.0;
                    double long2 = 1.0;
                    int volunt = dude.helping;
                    String distance = "···";
                    if (lat2 != 0.0) {
                      distance = model
                          .distanceBetween(
                            lat,
                            long,
                            lat2,
                            long2,
                          )
                          .toString();
                    }
                    return new GestureDetector(
                      onTap: () {
                        Map<String, dynamic> data = {
                          "id": main.model.user?.id,
                          "gonnahelp": g_id,
                        };
                        main.model.socket.emitWithAck('wanna_help', data,
                            ack: (back) {
                          print(back);
                          if (back["error"]) {
                            EasyLoading.showError(back["log"].toString(),
                                duration: Duration(seconds: 3));
                          } else if (back["log"] == "go on") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  main.model.globalTimer(Duration(seconds: 5));
                                  gl.doing = double.parse(g_id);
                                  return Helping();
                                },
                              ),
                            );
                          }
                        });
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: gl.height * 0.03),
                          decoration: BoxDecoration(
                            color: gl.tC,
                            borderRadius: BorderRadius.circular(
                                (gl.height / gl.width) * 3),
                          ),
                          width: gl.width * 0.8,
                          height: gl.height * 0.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: gl.width * 0.5,
                                    padding:
                                        EdgeInsets.only(left: gl.width * 0.05),
                                    child: ftext(name, 18.0, Colors.white,
                                        FontWeight.w700),
                                  ),
                                  Container(
                                    width: gl.width * 0.3,
                                    padding:
                                        EdgeInsets.only(right: gl.width * 0.1),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("$distance m", 17.0,
                                          Colors.white, FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: gl.height * 0.01),
                                    width: gl.width * 0.5,
                                    padding:
                                        EdgeInsets.only(left: gl.width * 0.05),
                                    child: ftext('$volunt voluntarios', 18.0,
                                        Colors.white, FontWeight.w500),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: gl.height * 0.01),
                                    width: gl.width * 0.3,
                                    padding:
                                        EdgeInsets.only(right: gl.width * 0.1),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ftext("Media", 17.0, Colors.white,
                                          FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),*/
          ),
          // ANCHOR HELP BUTTON
          GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Helped();
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                top: (gl.height * 0.05),
              ),
              width: gl.width * 0.8,
              height: gl.height * 0.06,
              decoration: BoxDecoration(
                color: gl.rC,
                borderRadius: BorderRadius.circular((gl.height / gl.width) * 3),
              ),
              child: Center(
                child:
                    ftext("Pedir Ayuda", 20.0, Colors.white, FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
