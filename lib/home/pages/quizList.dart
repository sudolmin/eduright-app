import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizListView extends StatelessWidget {
  const QuizListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final subjectSlug = data['sub']['slug'];
    final subClassData = {'sub': data['sub']['title'], 'class': data['class']};
    return Scaffold(
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

              final subjectData = quizSnapshot.data;
              final quizSetList = subjectData!["categoryquizset"];
              return Scaffold(
                backgroundColor: pagesBackgroundColor,
                appBar: genAppBar(subjectData['title']),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: quizSetList.length != 0
                      ? ListView.builder(
                          itemCount: quizSetList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var quizElement = quizSetList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryDarkThemeColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ExpansionTile(
                                      title: Text(quizElement['quizTitle']),
                                      subtitle: Text(
                                        'Topic: ${quizElement['quiztopic']}',
                                      ),
                                      children: [
                                        QuizSummaryRow(
                                          title: "Max Marks :",
                                          value: quizElement['max_marks'],
                                        ),
                                        QuizSummaryRow(
                                          title: "Marks Per Question :",
                                          value:
                                              quizElement['mark_per_question'],
                                          color: Colors.green.shade400,
                                        ),
                                        QuizSummaryRow(
                                          title: "Negative Marks",
                                          value:
                                              quizElement['negative_marking'],
                                          color: Colors.red.shade400,
                                        ),
                                        sizeBox(10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.toNamed('/quizleaderboard',
                                                    arguments: {
                                                      "quizName": quizElement[
                                                          "quizTitle"],
                                                      "quizSlug":
                                                          quizElement["setSlug"]
                                                    });
                                              },
                                              child: Text(
                                                "Leaderboard",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFFE4BD11),
                                                onSurface: Color(0xFFE4BD11),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.toNamed('/quizstartintro',
                                                    arguments: {
                                                      "quizSlug": quizElement[
                                                          'setSlug'],
                                                      "subClassData":
                                                          subClassData
                                                    });
                                              },
                                              child: Text(
                                                "Goto Quiz",
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 14),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFFE67DAC),
                                                onSurface: Color(0xFFE67DAC),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(child: Text("No Quiz Assigned to this Batch.")),
                ),
              );
            },
            future: handleQuizListQuery(subjectSlug)));
  }
}
