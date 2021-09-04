import 'package:flutter/material.dart';

const primaryThemeColor = Color(0xFFFC378F);
const secondaryThemeColor = Color(0xFFF5CCDE);

const primaryDarkThemeColor = Color(0xFFC21A65);
const secondaryDarkThemeColor = Color(0xFF944E6C);

final whiteColor = Colors.white;
final offWhite = Color(0xFFFFFFFF8);
final standardBlack = Colors.black.withAlpha(200);

final buttonSize = Size(200, 70);
const signBtnFontSize_G = 30.0;

// hive boxes
final userInfoBoxName = 'UserInfoBox';
final profileInfoBoxName = 'ProfileInfoBox';
final updateInfoBoxName = "UpdateInfoBox";
final categoryBoxName = "CategoryBox";
final homeTabBoxName = "HomeTabBox";

// hive keys
final loggedIn_Hkey = 'LoggedIn';

final userDataMsgDigest_Hkey = "userDataMsgDigest";
final classesMsgDigest_Hkey = "classesMsgDigest";
final cateDataMsgDigest_Hkey = "cateDataMsgDigest";

final classesListData_Hkey = "classesListData";
final classesList_bool_Hkey = "classesListBoolData";
final cateList_bool_Hkey = "cateListBoolData";

final subList_hash_Hkey = "subHash";

final updateProfile_bool_Hkey = "updateProfile";
final updateQuizList_bool_Hkey = "updateQuizList";

final bannerListData_Hkey = "bannerListData";
final bannerDataHash_Hkey = "bannerDataHash";
final banner_bool_Hkey = "bannerUpdateBool";

final linkListData_Hkey = "linkListData";
final linkDataHash_Hkey = "linkDataHash";
final link_bool_Hkey = "linkUpdateBool";

final infotabListData_Hkey = "infotabListData";
final infotabDataHash_Hkey = "infotabDataHash";
final infotab_bool_Hkey = "infotabUpdateBool";

// links
final privacyLink = "https://edurightinfo.web.app/privacy-policy.html";
