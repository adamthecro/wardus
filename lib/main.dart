library wardus.globals;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wardus/home.dart';
import 'package:wardus/load.dart';
import 'package:wardus/model.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Wakelock.enable();
  runApp(MyApp());
}

WModel model = WModel();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Load(model),
        builder: EasyLoading.init(),
      ),
    );
  }
}
