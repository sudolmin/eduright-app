import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/controller/profileController.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/home/utils/widgets.dart';
import 'package:eduapp/home/widget/shapes.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:eduapp/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProfileInfoView extends StatefulWidget {
  const ProfileInfoView({Key? key}) : super(key: key);

  @override
  _ProfileInfoViewState createState() => _ProfileInfoViewState();
}

class _ProfileInfoViewState extends State<ProfileInfoView> {
  @override
  void initState() {
    super.initState();
  }

  final profileCont = Get.put(ProfileController());
  String? dropdownValue;
  bool _firstBuild = true;
  @override
  Widget build(BuildContext context) {
    final _proBox = Hive.box(profileInfoBoxName);

    var profileInfoMap = _proBox.get("profileInfo");
    double _screenHeight = MediaQuery.of(context).size.height;

    Color _firstColor = Color(0xFFDD6090);
    Color _secondColor = Color(0xFFDA96B0);

    final classList = profileInfoMap.classList.cast<String>();

    return Scaffold(
      backgroundColor: pagesBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_firstColor, _secondColor])),
        ),
      ),
      body: CustomRefreshIndicator(
        onRefresh: () {
          return profile(mode: "refresh");
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(children: [
              CustomPaint(
                painter: AccountBackShape(
                  900,
                  0.9,
                  Color(0xCEF0B2C9),
                  firstColor: _firstColor,
                ),
                child: Container(
                  height: _screenHeight * 1 / 10,
                ),
              ),
              CustomPaint(
                painter: AccountBackShape(
                  1000,
                  0.6,
                  _secondColor,
                  firstColor: _firstColor,
                ),
                child: Container(
                  height: _screenHeight * 1 / 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Text(
                  'Personal Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]),
            sizeBox(40),
            profiletextfield("Username", requiredField,
                iconData: CupertinoIcons.person,
                initialValue: profileInfoMap.username,
                focusColor: primaryDarkThemeColor,
                labelColor: primaryDarkThemeColor,
                readonly: true),
            profiletextfield("Email", emailValidator,
                iconData: CupertinoIcons.at,
                initialValue: profileInfoMap.email,
                field: "email"),
            profiletextfield("Full Name", requiredField,
                iconData: CupertinoIcons.person_crop_square,
                initialValue: profileInfoMap.fullname,
                field: "fullName"),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      itemHeight: 80,
                      value:
                          _firstBuild ? profileInfoMap.standard : dropdownValue,
                      icon: Container(
                        decoration: BoxDecoration(
                          color: primaryThemeColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: const Text(
                            "Change",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      iconSize: 24,
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(
                          color: primaryThemeColor, fontSize: 18),
                      underline: Container(
                        height: 1,
                        color: primaryColor,
                      ),
                      onChanged: (String? newValue) {
                        // supController.supClass = newValue;
                        setState(() {
                          dropdownValue = newValue;
                          _firstBuild = false;
                        });
                        profileCont.updateButtonEnabled = true;
                        profileCont.standard = newValue;
                      },
                      items: classList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            sizeBox(12),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (profileCont.updateButtonEnabled) {
                    Get.snackbar("Please Wait", "Processing your request.");
                    final _resp = await profileDataUpdate({
                      "email": profileCont.email,
                      "fullName": profileCont.fullName,
                      "standard": dropdownValue
                    });
                    if (_resp["code"] == "UP200") {
                      Get.snackbar("Response", _resp["message"]);
                    }
                  } else {
                    print("disabled");
                  }
                },
                child: Text("Update"),
                style: ElevatedButton.styleFrom(
                    primary: profileCont.updateButtonEnabled
                        ? primaryThemeColor.withAlpha(200)
                        : Color(0xFF8D8D8D)),
              ),
            ),
            sizeBox(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: Text(
                "Badges",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Verified",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                      child: Icon(
                    Icons.verified_rounded,
                    color: profileInfoMap.verified
                        ? Colors.blue.shade400
                        : Colors.blueGrey.shade200,
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Student at Eduright Coaching",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                      child: Icon(
                    Icons.verified_rounded,
                    color: profileInfoMap.stdateduright
                        ? Colors.pink.shade300
                        : Colors.blueGrey.shade200,
                  ))
                ],
              ),
            ),
          ],
        ),
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  if (!controller.isIdle)
                    Positioned(
                      top: 35.0 * controller.value,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          value: !controller.isLoading
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: () async {
              await Get.defaultDialog(
                  title: "Review Your Action",
                  middleText:
                      "The following action is irreversible, this will delete your account as well as wipe all data directly related to this account. Are you sure you want to delete your account?",
                  textConfirm: "Yes, I'm sure. Goodbye",
                  textCancel: "No, take me back",
                  confirmTextColor: Colors.white,
                  cancelTextColor: primaryThemeColor,
                  radius: 0,
                  onCancel: () {
                    return;
                  },
                  onConfirm: () async {
                    Get.snackbar("Please Wait", "Processing your request.");
                    final _resp = await accountDelete();
                    if (_resp["code"] == "DSA200") {
                      Get.snackbar("Response", _resp["message"]);
                      await Future.delayed(Duration(seconds: 2));
                      Get.offAllNamed("/signmainpage");
                    } else {
                      Get.snackbar("Response", _resp["message"]);
                      Get.offAllNamed("/signmainpage");
                    }
                    return;
                  });
            },
            child: Text(
              "Delete my account.",
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }
}

// 