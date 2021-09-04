import 'package:eduapp/login/controller/signController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import 'constants.dart';

SizedBox sizeBox(double height) {
  return SizedBox(
    height: height,
  );
}

final signCont = Get.find<SignController>();

TextFormField formtextfield(String label, IconData iconData, Color focusColor,
    Color labelColor, String field, MultiValidator validators) {
  return TextFormField(
      style: TextStyle(color: focusColor, fontSize: 18),
      key: Key(field),
      onChanged: (str) {
        switch (field) {
          case "supusername":
            signCont.supUsrnme = str;
            break;
          case "supfname":
            signCont.supFName = str;
            break;
          case "supemail":
            signCont.supEmail = str;
            break;
          case "suppwd1":
            signCont.supPwd1 = str;
            break;
          case "suppwd2":
            signCont.supPwd2 = str;
            break;

          case "sinusrnme":
            signCont.sinUsrnme = str;
            break;
          case "sinpwd":
            signCont.sinPwd = str;
            break;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: field == "suppwd1"
          ? signCont.supPwd1Obsc
          : field == "suppwd2"
              ? signCont.supPwd2Obsc
              : field == "sinpwd"
                  ? signCont
                      .sinPwdObsc // these states are defined to toggle password show/hide
                  : false,
      validator: validators, // validators.dart
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor, fontSize: 18),
          icon: Icon(
            iconData,
            color: labelColor,
          ),
          // suffixIcon: field == "suppwd1" || field == "suppwd2"
          //     ? IconButton(
          //         onPressed: () {
          //           if (field == "suppwd1") {
          //             signCont.supPwd1Obsc = !signCont.supPwd1Obsc;
          //             print(signCont.supPwd1Obsc);
          //           }
          //           if (field == "suppwd2") {
          //             signCont.supPwd2Obsc = !signCont.supPwd2Obsc;
          //           }
          //         },
          //         icon: Icon(
          //           Icons.remove_red_eye,
          //         ))
          //     : null,        // adding hide/show password ICON button
          focusColor: focusColor,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: focusColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: focusColor))),
      keyboardType: field == "supemail"
          ? TextInputType.emailAddress
          : TextInputType.text);
}

ElevatedButton elevatedButton(
    String text, Function onPressFunc, Color textColor, Color surfaceColor,
    {Size btnSize = signBtnSize}) {
  return ElevatedButton(
    onPressed: () {
      onPressFunc();
    },
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: signBtnFontSize),
    ),
    style: ElevatedButton.styleFrom(
      primary: surfaceColor,
      side: BorderSide(width: 2.0, color: primaryColor),
      onSurface: surfaceColor,
      minimumSize: signBtnSize,
    ),
  );
}

ElevatedButton progressButton(Color indiolor, Color surfaceColor) {
  return ElevatedButton(
    onPressed: () {
      print("");
    },
    child: CircularProgressIndicator(
      color: indiolor,
    ),
    style: ElevatedButton.styleFrom(
      primary: surfaceColor,
      side: BorderSide(width: 2.0, color: primaryColor),
      onSurface: surfaceColor,
      minimumSize: signBtnSize,
    ),
  );
}
