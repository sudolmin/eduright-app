import 'package:eduapp/login/controller/signController.dart';
import 'package:eduapp/login/utils/buttonFunctions.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:eduapp/validators.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final supController = Get.put(SignController());
  bool _signinProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: Get.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                            style: TextStyle(color: primaryColor, fontSize: 18),
                            key: Key('sinusername'),
                            onChanged: (str) {
                              supController.sinUsrnme = str;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: usernameValidator, // validators.dart
                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                    color: primaryColor, fontSize: 18),
                                icon: Icon(
                                  CupertinoIcons.person_alt,
                                  color: primaryColor,
                                ),
                                focusColor: primaryColor,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: primaryColor))),
                            keyboardType: TextInputType.text),
                        TextFormField(
                            style: TextStyle(color: primaryColor, fontSize: 18),
                            key: Key("sinpwd"),
                            onChanged: (str) {
                              supController.sinPwd = str;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            validator: passwordValidator, // validators.dart
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: primaryColor, fontSize: 18),
                                icon: Icon(
                                  CupertinoIcons.lock_fill,
                                  color: primaryColor,
                                ),
                                focusColor: primaryColor,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: primaryColor)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: primaryColor))),
                            keyboardType: TextInputType.text),
                        sizeBox(40),
                        _signinProgress
                            ? progressButton(primaryColor, whiteColor)
                            : elevatedButton('Login', () async {
                                if (_formKey.currentState!.validate()) {
                                  final dataMap = {
                                    'username': supController.sinUsrnme,
                                    "password": supController.sinPwd,
                                  };
                                  Get.snackbar(
                                      "Please Wait", "Trying to log you in.");
                                  setState(() {
                                    _signinProgress = !_signinProgress;
                                  });
                                  var _resp = await signinpagefunc(dataMap);
                                  if (_resp['login'] == "true") {
                                    Get.snackbar(
                                      "Login Successful",
                                      'Welcome Back, ${_resp["username"]}',
                                    );
                                    await Future.delayed(Duration(seconds: 1));
                                    Get.offAllNamed(
                                        '/homeview'); //use Get.off(..) in prod
                                  } else {
                                    Get.snackbar("Cannot Log In",
                                        "Please check your credentials.");
                                  }
                                  setState(() {
                                    _signinProgress = !_signinProgress;
                                  });
                                }
                              }, primaryColor, whiteColor)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
