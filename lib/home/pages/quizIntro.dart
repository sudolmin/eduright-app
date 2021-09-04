import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizIntro extends StatelessWidget {
  const QuizIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final quizSlug = data["quizSlug"];
    final subClassData = data["subClassData"];
    print(data);
    return Scaffold(
        backgroundColor: pagesBackgroundColor,
        body: FutureBuilder(
          builder: (context, AsyncSnapshot<Map> quizSnapshot) {
            if (quizSnapshot.connectionState == ConnectionState.none &&
                quizSnapshot.hasData == false) {
              return Container();
            }
            if (quizSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            }
            final data = quizSnapshot.data!;
            print(data);

            int timeLimit = data["timeLimit"];
            int secs = timeLimit % 60;
            int mins = timeLimit ~/ 60;
            String mins_ = "$mins";
            String secs_ = "$secs";
            if (mins < 10) {
              mins_ = "0$mins";
            }
            if (secs < 10) {
              secs_ = "0$secs";
            }

            return Scaffold(
              backgroundColor: pagesBackgroundColor,
              body: SafeArea(
                  child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 85,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                            color: Colors.lightBlue.shade400),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 3),
                                      child: Text(
                                        subClassData["class"],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          border: Border.all(
                                              color:
                                                  Colors.lightGreen.shade400),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 3),
                                        child: Text(
                                          subClassData["sub"],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              child: Text(
                            data["quizTitle"],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          )),
                          sizeBox(16),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Summary:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                                sizeBox(8),
                                QuizSummaryRow(
                                  title: "Max Marks :",
                                  value: data['max_marks'],
                                ),
                                QuizSummaryRow(
                                  title: "Marks Per Question :",
                                  value: data['mark_per_question'],
                                  color: Colors.green.shade400,
                                ),
                                QuizSummaryRow(
                                  title: "Negative Marks",
                                  value: data['negative_marking'],
                                  color: Colors.red.shade400,
                                ),
                                QuizSummaryRow(
                                  title: "Max Time",
                                  value: "$mins_:$secs_ mins",
                                  color: Colors.blue.shade400,
                                ),
                              ],
                            ),
                          ),
                          sizeBox(16),
                          Container(
                            child: Text(
                              "Description:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          sizeBox(8),
                          Container(
                            child: Text(data["description"]),
                          ),
                          sizeBox(16),
                          Container(
                            child: Text(
                              "Note:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          sizeBox(8),
                          Container(
                              child: RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                TextSpan(
                                    text:
                                        "1. You'll be navigated to the test page, when you click on the "),
                                TextSpan(
                                    text: "Start",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        backgroundColor: Color(0xFFE67DAC),
                                        color: whiteColor)),
                                TextSpan(
                                    text:
                                        " button, and the timer is initialized. "),
                                TextSpan(
                                    text:
                                        "Once the paper starts you cannot go back until it gets submitted."),
                              ]))),
                          sizeBox(6),
                          Container(
                              child: RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                TextSpan(
                                    text:
                                        "2. Please do read the instructions carefully. You can attempt these quizes as many times as you wish. But your attempt is saved "),
                                TextSpan(
                                    text: "only once.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    )),
                                TextSpan(
                                    text:
                                        "So be advised you should only tap on the start button when you are sure you want to continue."),
                              ]))),
                          sizeBox(6),
                          Container(
                            child: RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                  TextSpan(
                                      text:
                                          "3. To navigate through the paper you can "),
                                  TextSpan(
                                      text: "slide through ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                                  TextSpan(text: "the pages, "),
                                  TextSpan(
                                      text: "tap on Next and Prev buttons",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                                  TextSpan(
                                      text:
                                          " or open the question list drawer bottom sheet with "),
                                  TextSpan(
                                      text: "upward drag motion.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ])),
                          ),
                          sizeBox(6),
                          Container(
                              child: RichText(
                                  text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                TextSpan(text: "4. Once the timer hits "),
                                TextSpan(
                                    text: "00:00",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade400,
                                    )),
                                TextSpan(
                                    text:
                                        " the paper along with your attempted responses is submitted automatically."),
                              ]))),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(color: whiteColor, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue.shade200,
                                onSurface: primaryDarkThemeColor,
                                fixedSize: Size(100, 40)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.offAllNamed('/quizpage', arguments: data);
                            },
                            child: Text(
                              "Start",
                              style: TextStyle(color: whiteColor, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFE67DAC),
                                onSurface: Color(0xFFE67DAC),
                                fixedSize: Size(100, 40)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            );
          },
          future: handleQuizData(quizSlug),
        ));
  }
}
