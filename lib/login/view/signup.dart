import 'package:eduapp/globals.dart';
import 'package:eduapp/login/controller/signController.dart';
import 'package:eduapp/login/utils/buttonFunctions.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:eduapp/validators.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final supController = Get.put(SignController());
  bool _signupProgress = false;

  List classListDyn = Get.arguments;

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<String> classList = [];
    for (var cls in classListDyn) {
      classList.add(cls["class"]);
    }

    // final classList = classListDyn.cast<String>();
    classList = classList.cast<String>();
    bool pwd1obscure = true;
    bool pwd2obscure = true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: Get.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                              key: Key('supusername'),
                              onChanged: (str) {
                                supController.supUsrnme = str;
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
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                              key: Key('supfname'),
                              onChanged: (str) {
                                supController.supFName = str;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: requiredField, // validators.dart
                              decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  labelStyle: TextStyle(
                                      color: primaryColor, fontSize: 18),
                                  icon: Icon(
                                    CupertinoIcons.textformat_abc,
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 0),
                              child: Container(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    itemHeight: 80,
                                    value: dropdownValue,
                                    hint: Text(
                                      "You are in ..",
                                      style: TextStyle(
                                          color: primaryThemeColor,
                                          fontSize: 18),
                                    ),
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: primaryThemeColor),
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
                                      supController.supClass = newValue;
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: classList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                          TextFormField(
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                              key: Key("supemail"),
                              onChanged: (str) {
                                supController.supEmail = str;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: emailValidator, // validators.dart
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: primaryColor, fontSize: 18),
                                  icon: Icon(
                                    CupertinoIcons.at,
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
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                              key: Key("suppwd1"),
                              onChanged: (str) {
                                supController.supPwd1 = str;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: pwd1obscure,
                              validator: passwordValidator, // validators.dart
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: primaryColor, fontSize: 18),
                                  icon: Icon(
                                    CupertinoIcons.lock,
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
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                              key: Key("suppwd2"),
                              onChanged: (str) {
                                supController.supPwd2 = str;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: pwd2obscure,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'This field is required';
                                if (value != supController.supPwd1)
                                  return 'Passwords should match';
                                return null;
                              }, // validators.dart
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
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
                          sizeBox(20),
                          _signupProgress
                              ? progressButton(Colors.white, primaryColor)
                              : elevatedButton('Sign Up', () async {
                                  if (_formKey.currentState!.validate() &&
                                      supController.supClass != null) {
                                    final dataMap = {
                                      'username': supController.supUsrnme,
                                      'fullname': supController.supFName,
                                      "password": supController.supPwd2,
                                      "email": supController.supEmail,
                                      "class": supController.supClass
                                    };
                                    setState(() {
                                      _signupProgress = !_signupProgress;
                                    });
                                    Get.snackbar("Please Wait",
                                        "Processing your request.");
                                    var _resp = await signuppagefunc(dataMap);
                                    if (_resp["code"] == "UC200") {
                                      Get.snackbar(_resp["responseTitle"],
                                          _resp["message"]);
                                      await Future.delayed(
                                          Duration(milliseconds: 3000));
                                      Get.toNamed(
                                          "/signinpage"); //use Get.off(..) in prod
                                    }
                                    setState(() {
                                      _signupProgress = !_signupProgress;
                                    });
                                  }
                                }, Colors.white, primaryColor),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextButton(
                                onPressed: () async {
                                  print("Privacy");

                                  if (await canLaunch(privacyLink)) {
                                    launch(privacyLink);
                                    print("Privacy");
                                  }
                                },
                                child: Text("Privacy Policy")),
                          )
                        ],
                      ),
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
