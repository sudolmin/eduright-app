import 'package:eduapp/login/controller/signController.dart';
import 'package:eduapp/login/utils/apiService.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage>
    with SingleTickerProviderStateMixin {
  bool showProgress = false;

  final csrfController = Get.put(CSRFController());

  AnimationController? animationController;
  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: new Duration(milliseconds: 400), vsync: this);
    animationController!.repeat();
  }

  Future tapCheckInternet(String namedPage, {bool getClasslist = false}) async {
    setState(() {
      showProgress = !showProgress;
    });
    final result = await checkInternet();

    if (result) {
      List classList = [];
      if (getClasslist) {
        classList = await getClassList();
      }
      Get.toNamed(namedPage, arguments: classList);
    }
    if (!result) {
      Get.snackbar(
          "Network Error", "Please make sure you're connected to the internet.",
          margin: EdgeInsets.only(top: 10));
    }
    setState(() {
      showProgress = !showProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showProgress
          ? Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                    color: Color(0xFFD8AFC1),
                    strokeWidth: 10,
                    backgroundColor: Colors.teal.shade50,
                    valueColor: animationController!.drive(ColorTween(
                        begin: Color(0xFFDF0064), end: Color(0xFF9B0046)))),
              ),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/undraw_dreamer_gxxi.png'),
                  SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await tapCheckInternet('/signinpage');
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white, fontSize: signBtnFontSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      minimumSize: signBtnSize,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await tapCheckInternet('/signuppage', getClasslist: true);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: primaryColor, fontSize: signBtnFontSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(width: 2.0, color: primaryColor),
                      onSurface: primaryColor,
                      minimumSize: signBtnSize,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
