import 'package:eduapp/globals.dart';
import 'package:eduapp/login/controller/signController.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'apiService.dart';

final csrfController = Get.put(CSRFController());

Future signinpagefunc(dataMap) async {
  var resp = await login(dataMap);
  if (resp['login'] == "true") {
    Hive.box(userInfoBoxName).put(loggedIn_Hkey, true);
  }
  return resp;
}

Future signuppagefunc(dataMap) async {
  var resp = await createUser(dataMap);
  return resp;
}
