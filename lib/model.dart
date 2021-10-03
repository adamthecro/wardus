import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wardus/helped.dart';
import 'package:wardus/home.dart';
import 'package:wardus/start.dart';
import 'package:http/http.dart' as http;
// Globals
import 'globals.dart' as gl;

class WModel extends Model {
  Socket socket = io('http://192.168.1.133:3000', <String, dynamic>{
    'transports': ['websocket'],
  });

  List<NeedHelpData> needhelplist = [];

  List<UserData> helpingdatalist = [];
  List<UserData> helpeddatalist = [];

  UserData userData = new UserData();

  // ANCHOR Initializer
  void init() async {
    print("Initializing model");
    EasyLoading.init();

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = false
      ..dismissOnTap = true;
    //socketmanager();
    sessionmanager();
    checkGeoPermissions();
  }

  // ANCHOR DO STUFF
  void getHelp() {
    print("GETIIING HEEEEELP");
    if (gl.doing != 1) {
      gl.doing = 1;
      socket.emitWithAck('help', user?.id, ack: (back) {
        print(back);
        if (back["error"]) {
          EasyLoading.showError(back["log"].toString(),
              duration: Duration(seconds: 3));
        } else if (back["log"] == "go on") {
          globalTimer(Duration(seconds: 5));
          Get.off(() => Helped());
        }
      });
    }
  }

  void cancelgetHelp() {
    socket.emit("cancelhelp", user?.id);
    gl.doing = 0;
    globalTimer(Duration(seconds: 90));
    Get.off(() => Home());
  }

  // ANCHOR User and Login
  var logInListener;
  GoogleSignInAccount? user;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.gender.read',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
  ]);
  void sessionmanager() async {
    logInListener = googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) async {
        print("LoginListener");
        user = account;
        if (user == null) {
          handleRegister();
          Get.off(() => Start());
        } else {
          globalTimer(Duration(seconds: 90));
          Get.off(Home());
        }
      },
    );
    googleSignIn.signInSilently();
    if (!await googleSignIn.isSignedIn()) {
      handleRegister();
      Get.off(() => Start());
    }
  }

  bool sLoged = false;
  void socketLogin() async {
    if (await googleSignIn.isSignedIn()) {
      socket.emitWithAck('login', user?.id, ack: (back) {
        if (back["error"]) {
          EasyLoading.showError(back["log"].toString(),
              duration: Duration(seconds: 3));
          googleSignIn.signOut();
        } else {
          sLoged = true;
          List<dynamic> temp = jsonDecode(back["log"]);
          needhelplist = [];
          for (int i = 0; i < temp.length; i++) {
            needhelplist.add(needhelpfromJson(temp[i]));
          }
          notifyListeners();
          Get.off(() => Home());
        }
      });
    }
  }

  var signInListener;

  void handleRegister() async {
    logInListener.cancel();
    signInListener = googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) async {
        print("SignupListener");
        user = account;
        if (user == null) {
          Get.to(() => Start());
        } else {
          final http.Response response = await http.get(
            Uri.parse(
                'https://people.googleapis.com/v1/people/me?personFields=genders,birthdays,phoneNumbers'),
            headers: await user!.authHeaders,
          );
          dynamic resp = jsonDecode(response.body);
          String gender = "";
          String birthday = "0000-00-00";
          if (resp["genders"] != null) {
            gender = resp?["genders"][0]["value"];
          }
          if (resp["birthdays"] != null) {
            birthday = resp["birthdays"][0]["date"]["year"].toString() +
                "-" +
                resp["birthdays"][0]["date"]["month"].toString() +
                "-" +
                resp["birthdays"][0]["date"]["day"].toString();
          }
          Map<String, dynamic> data = {
            "id": user?.id,
            "name": user?.displayName,
            "email": user?.email,
            "photoUrl": user?.photoUrl,
            "gender": gender,
            "birthday": birthday,
          };
          socket.emitWithAck('register', data, ack: (back) {
            print(back);
            if (back["error"]) {
              Get.snackbar("Error", back["log"]);
              googleSignIn.signOut();
            } else if (back["log"] == "go on") {
              signInListener.cancel();
              sessionmanager();
              socketLogin();
            }
          });
        }
      },
    );
  }

  // ANCHOR Socket manager
  bool sDisc = false;
  void socketmanager() {
    socket.connect();
    EasyLoading.show(status: 'Conectandose al servidor...');
    socket.onConnect((_) {
      EasyLoading.dismiss();
      if (sDisc) {
        if (gl.doing == 1) {
          gl.doing = 0;
          getHelp();
        }
        socketLogin();
      }
    });
    socket.onReconnect((_) {
      EasyLoading.dismiss();
    });
    socket.onError((data) {
      EasyLoading.show(status: 'Se ha perdido la conexion con el servidor');
    });
    socket.onConnectTimeout((data) {
      EasyLoading.show(status: 'Se ha perdido la conexion con el servidor');
    });
    socket.onDisconnect((data) {
      sDisc = true;
      sLoged = false;
      cancelgetHelp();
      EasyLoading.show(status: 'Se ha perdido la conexion con el servidor');
    });
    socket.onReconnectFailed((data) {
      EasyLoading.show(status: 'Se ha perdido la conexion con el servidor');
    });

    // Data listeners
    socket.on(
      "needhelp",
      (data) {
        print(data["name"]);
        needhelplist.add(needhelpfromJson(data));
        notifyListeners();
      },
    );
    // Data listeners
    socket.on(
      "needhelplist",
      (data) {
        List<dynamic> temp = jsonDecode(data);
        needhelplist = [];
        for (int i = 0; i < temp.length; i++) {
          needhelplist.add(needhelpfromJson(temp[i]));
        }
        notifyListeners();
      },
    );

    // Data listeners
    socket.on(
      "helpedinfo",
      (data) {
        List<dynamic> temp = jsonDecode(data);
        needhelplist = [];
        for (int i = 0; i < temp.length; i++) {
          needhelplist.add(needhelpfromJson(temp[i]));
        }
        notifyListeners();
      },
    );
  }

  // ANCHOR GeoLocation
  Location location = new Location();

  bool _serviceEnabled = false;

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  void checkGeoPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        EasyLoading.showError(
            "No se han podido obtener los datos de localización");
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        EasyLoading.showError(
            "No se han podido obtener los datos de localización");
      }
    }

    location.enableBackgroundMode(enable: true);
    location.changeSettings(accuracy: LocationAccuracy.navigation);
  }

  // ANCHOR Global functions
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  int distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    int earthRadiusKm = 6371000;

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return (earthRadiusKm * c).round();
  }

  // ANCHOR Global Interval
  Timer gTimer = Timer.periodic(Duration(days: 1), (timer) async {});
  void globalTimer(Duration time) {
    if (gTimer.isActive) {
      gTimer.cancel();
    }
    sendLocData();
    gTimer = Timer.periodic(time, (timer) async {
      sendLocData();
    });
  }

  void sendLocData() async {
    if (sLoged) {
      LocationData locationData = await location.getLocation();
      Map<String, dynamic> data = {
        "g_id": user?.id, // FIXME OLEEEE
        "latitude": locationData.latitude,
        "longitude": locationData.longitude,
        "altitude": locationData.altitude,
        "accuracy": locationData.accuracy,
        "heading": locationData.heading,
        "speed": locationData.speed,
        "timestamp": locationData.time,
        "doing": gl.doing,
      };
      socket.emit("location", data);
    }
  }
}

class UserData {
  String id;
  String name;
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  double timestamp;

  UserData([
    this.id = "null",
    this.name = "null",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.altitude = 0.0,
    this.accuracy = 0.0,
    this.timestamp = 0.0,
  ]);
}

UserData usedatafromJson(data) {
  return UserData(
    data["id"],
    data["name"],
    data["lat"].toDouble(),
    data["long"].toDouble(),
    data["alt"].toDouble(),
    data["accu"].toDouble(),
    data["lastu"].toDouble(),
  );
}

class NeedHelpData {
  String id;
  String name;
  double latitude;
  double longitude;
  double altitude;
  double accuracy;
  double timestamp;
  int helping;

  NeedHelpData(this.id, this.name, this.latitude, this.longitude, this.altitude,
      this.accuracy, this.timestamp, this.helping);
}

NeedHelpData needhelpfromJson(data) {
  return NeedHelpData(
    data["id"],
    data["name"],
    data["lat"].toDouble(),
    data["long"].toDouble(),
    data["alt"].toDouble(),
    data["accu"].toDouble(),
    data["lastu"].toDouble(),
    data["helping"] = data["helping"].length,
  );
}
