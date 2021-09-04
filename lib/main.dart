import 'package:eduapp/home/view/home.dart';
import 'package:eduapp/login/view/signMain.dart';
import 'package:eduapp/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'globals.dart';
import 'home/models/profileInfoModel.dart';

void main() async {
  // registering adapters
  Hive.registerAdapter(ProfileInfoAdapter());

  await Hive.initFlutter('hiveDb');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Eduright',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          fontFamily: GoogleFonts.overpass().fontFamily),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Hive.openBox(userInfoBoxName),
        builder: (BuildContext context, AsyncSnapshot<Box> usrInfoBoxSnapshot) {
          if (usrInfoBoxSnapshot.connectionState == ConnectionState.done) {
            if (usrInfoBoxSnapshot.hasError) {
              return Text(usrInfoBoxSnapshot.error.toString());
            } else {
              Box userInfoBox = usrInfoBoxSnapshot.requireData;
              bool loggedIn = userInfoBox.get(loggedIn_Hkey,
                  defaultValue:
                      false); // default value:: if the value for given key doesnot exit it will return that value
              return loggedIn ? HomeView() : SignPage();
            }
          } else if (usrInfoBoxSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Scaffold(
                body: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: Color(0xFFF1408D),
                  strokeWidth: 10,
                  backgroundColor: Colors.teal.shade50,
                ),
              ),
            ));
          } else {
            return Scaffold();
          }
        },
      ),

      getPages: routeMap, // include all the routes in route map
    );
  }
}
