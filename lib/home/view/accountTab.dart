import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/widget/accTabOptions.dart';
import 'package:eduapp/home/widget/shapes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    Hive.openBox(profileInfoBoxName);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    // Hive.box(profileInfoBoxName).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: pagesBackgroundColor,
      child: Column(children: [
        Stack(children: [
          CustomPaint(
            painter: AccountBackShape(800, 0.9, secondaryThemeColor),
            child: Container(
              height: _screenHeight * 1 / 4,
            ),
          ),
          CustomPaint(
            painter:
                AccountBackShape(500, 0.6, primaryThemeColor.withGreen(100)),
            child: Container(
              height: _screenHeight * 1 / 4,
            ),
          ),
          Container(
            height: _screenHeight * 1 / 4 + 60,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Icon(
                  CupertinoIcons.person_alt,
                  size: 80,
                  color: secondaryThemeColor.withBlue(255),
                ),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(4.0, 4.0),
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.2))
                    ]),
              ),
            ),
          ),
        ]),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: ListOfAccOptWidgets.widgetlist,
              )),
        )
      ]),
    );
  }
}
