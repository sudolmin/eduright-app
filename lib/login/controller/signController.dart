import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignController extends GetxController {
  String sinUsrnme = "";
  String sinPwd = "";

  String supUsrnme = "";
  String supFName = "";
  String supEmail = "";
  String supPwd1 = "";
  String supPwd2 = "";
  String? supClass = "";

  bool sinPwdObsc = true;
  bool supPwd1Obsc = true;
  bool supPwd2Obsc = true;
}

class CSRFController extends GetxController {
  String csrfToken = "";
}
