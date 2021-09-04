import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ListOfAccOptWidgets {
  static final List<Widget> widgetlist = [
    ListContainer(
      leadIcon: CupertinoIcons.profile_circled,
      leadIconColor: primaryDarkThemeColor.withOpacity(0.9),
      titleTextColor: primaryDarkThemeColor.withOpacity(0.8),
      bgcolor: Colors.white,
      contHeight: 60,
      contradius: 8,
      inkSplashColor: secondaryColor,
      title: "Profile",
      onTapFunc: () async {
        await profile();
        Get.toNamed('/profileinfo');
      },
    ),

    // disabled for this release

    // ListContainer(
    //   leadIcon: CupertinoIcons.settings,
    //   leadIconColor: primaryDarkThemeColor.withOpacity(0.9),
    //   titleTextColor: primaryDarkThemeColor.withOpacity(0.8),
    //   bgcolor: Colors.white,
    //   contHeight: 60,
    //   contradius: 8,
    //   inkSplashColor: secondaryColor,
    //   title: "Settings",
    //   onTapFunc: settings,
    // ),
    ListContainer(
      leadIcon: CupertinoIcons.info_circle,
      leadIconColor: primaryDarkThemeColor.withOpacity(0.9),
      titleTextColor: primaryDarkThemeColor.withOpacity(0.8),
      bgcolor: Colors.white,
      contHeight: 60,
      contradius: 8,
      inkSplashColor: secondaryColor,
      title: "About",
      onTapFunc: () async {
        Get.toNamed('/about');
      },
    ),
    ListContainer(
      leadIcon: Icons.logout_rounded,
      leadIconColor: primaryDarkThemeColor.withOpacity(0.9),
      titleTextColor: primaryDarkThemeColor.withOpacity(0.8),
      bgcolor: Colors.white,
      contHeight: 60,
      contradius: 8,
      inkSplashColor: secondaryColor,
      title: "Logout",
      verPad: 30,
      onTapFunc: () async {
        Get.snackbar("Processing your Request", "Please Wait");
        final resp = await logoutHandler();
        if (resp) {
          Get.snackbar(
            "Request Successful",
            "You are logged out of your account successfully. Redirecting you to SignUp page.",
          );

          await Hive.box(userInfoBoxName).clear();
          await Hive.box(profileInfoBoxName).clear();
          await Hive.box(updateInfoBoxName).clear();

          await Future.delayed(Duration(seconds: 1));
          Get.offAllNamed('/signmainpage');
        } else {
          Get.snackbar("Request Failed",
              "Please check your connectivity. Or try again later.");
        }
      },
    ),
  ];
}
