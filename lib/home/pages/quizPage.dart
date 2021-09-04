import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/controller/quizController.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/home/widget/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void dispose() {
    super.dispose();
    Get.find<QuizController>().countdown(mode: "dispose");
    Get.delete<QuizController>();
  }

  @override
  Widget build(BuildContext context) {
    final quizData = Get.arguments;
    final questions = quizData['questions'];

    final quizController_g = Get.put(QuizController());

    quizController_g.max_marks = quizData['max_marks'];
    quizController_g.mark_per_question = quizData['mark_per_question'];
    quizController_g.negative_marking = quizData['negative_marking'];
    quizController_g.quizName = quizData['quizTitle'];
    quizController_g.questions = quizData['questions'];
    quizController_g.quizSlug = quizData['setSlug'];

    quizController_g.answerMarksList = List<int>.filled(questions.length, 0);
    quizController_g.answerAttempts =
        List<String>.filled(questions.length, "unattempted");

    final PageController _pageController = PageController();

    quizController_g.countdown();
    quizController_g.timerLeft = quizData['timeLimit'];

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: pagesBackgroundColor,
        body: SafeArea(
            child: Stack(
          children: [
            PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  var question = questions[index];
                  var quesIndex = index;
                  var questionWrap = Wrap();
                  if (question['lateX']) {
                    final longEq = Math.tex(
                      question['quesText'],
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    );
                    final breakResult = longEq.texBreak();
                    questionWrap = Wrap(
                      children: breakResult.parts,
                    );
                  }

                  return Container(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black12))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Time left : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87)),
                                    GetBuilder<QuizController>(
                                      builder: (_) {
                                        int timeLeft =
                                            quizController_g.timerLeft;
                                        int secs = timeLeft % 60;
                                        int mins = timeLeft ~/ 60;
                                        String mins_ = "$mins";
                                        String secs_ = "$secs";
                                        if (mins < 10) {
                                          mins_ = "0$mins";
                                        }
                                        if (secs < 10) {
                                          secs_ = "0$secs";
                                        }

                                        Color timerColor = timeLeft > 10
                                            ? Colors.green.shade700
                                            : Colors.red.shade700;

                                        return Text(
                                          "$mins_:$secs_",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: timerColor),
                                        );
                                      },
                                    )
                                  ],
                                )),
                                Container(
                                    child: Row(
                                  children: [
                                    Text("${index + 1}/"),
                                    Text(
                                      "${questions.length}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 18),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                            color: pagesBackgroundColor,
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: question['imageQuestion'] == null
                                    ? SingleChildScrollView(
                                        child: !question['lateX']
                                            ? Text(
                                                '${question['quesText']}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                ),
                                              )
                                            : questionWrap,
                                      )
                                    : ListView(
                                        children: [
                                          !question['lateX']
                                              ? Text(
                                                  '${question['quesText']}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                  ),
                                                )
                                              : questionWrap,
                                          Container(
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    question['imageHeight'] *
                                                        1.0),
                                            child: Image.network(
                                                '${question['imageQuestion']}'),
                                          )
                                        ],
                                      ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: pagesBackgroundColor,
                                border: Border(
                                    bottom: BorderSide(color: Colors.black12))),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: GetBuilder<QuizController>(
                          builder: (quizController) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: question['answers'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  var answer = question['answers'][index];
                                  bool selectBool = quizController
                                              .selectedIndexMap[quesIndex] ==
                                          null
                                      ? false
                                      : quizController
                                              .selectedIndexMap[quesIndex] ==
                                          index;
                                  Color defaultTextColor = Colors.black87;
                                  var answerWrap = Wrap();
                                  if (answer['lateX']) {
                                    final longEq = Math.tex(
                                      answer['option'],
                                      textStyle: TextStyle(
                                        fontSize: 19,
                                        color: Colors.black87,
                                      ),
                                    );
                                    final breakResult = longEq.texBreak();
                                    answerWrap = Wrap(
                                      children: breakResult.parts,
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: primaryThemeColor
                                                  .withAlpha(200))),
                                      child: ListTile(
                                        // contentPadding: ,
                                        tileColor: whiteColor,
                                        title: !answer['lateX'] &&
                                                answer['option'] != null
                                            ? Text(
                                                "${answer['option']}",
                                                style: TextStyle(
                                                    color: selectBool
                                                        ? whiteColor
                                                        : defaultTextColor),
                                              )
                                            : answer['lateX'] &&
                                                    answer['option'] != null
                                                ? answerWrap
                                                : null,
                                        subtitle: answer['imageOption'] != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 18),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight: answer[
                                                              'imageHeight'] *
                                                          1.0),
                                                  child: Image.network(
                                                      '${answer['imageOption']}'),
                                                ),
                                              )
                                            : null,

                                        selectedTileColor:
                                            primaryThemeColor.withAlpha(200),
                                        selected: selectBool,
                                        onTap: () {
                                          if (quizController.selectedIndexMap[
                                                  quesIndex] ==
                                              index) {
                                            quizController.selectedIndexMap[
                                                quesIndex] = -1;

                                            quizController_g.reset(quesIndex);
                                          } else {
                                            quizController.selectedIndexMap[
                                                quesIndex] = index;
                                            if (answer['correct'] == true) {
                                              quizController_g
                                                  .increment(quesIndex);
                                            } else {
                                              quizController_g
                                                  .decrement(quesIndex);
                                            }
                                          }
                                          quizController.update();
                                        },
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: pagesBackgroundColor,
                                border: Border(
                                    top: BorderSide(color: Colors.black12))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight > 700 ? 10 : 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  QuizElevatedButton(
                                    title: "Prev",
                                    size: screenHeight > 700
                                        ? Size(120, 50)
                                        : Size(100, 40),
                                    textColor: quesIndex == 0
                                        ? Color(0xFFAD8BB4)
                                        : primaryThemeColor,
                                    borderColor: quesIndex == 0
                                        ? Color(0xFFAD8BB4)
                                        : primaryThemeColor,
                                    surfaceColor: whiteColor,
                                    elevation: quesIndex == 0 ? 0 : 5,
                                    tapFunc: quesIndex == 0
                                        ? () {
                                            print('Not Clickable');
                                          }
                                        : () {
                                            _pageController
                                                .jumpToPage(quesIndex - 1);
                                          },
                                  ),
                                  QuizElevatedButton(
                                    title: quesIndex == questions.length - 1
                                        ? "Submit"
                                        : "Next",
                                    size: screenHeight > 700
                                        ? Size(120, 50)
                                        : Size(100, 40),
                                    elevation: 5,
                                    surfaceColor: primaryThemeColor,
                                    tapFunc: () async {
                                      quesIndex != questions.length - 1
                                          ? _pageController
                                              .jumpToPage(quesIndex + 1)
                                          : await Get.defaultDialog(
                                              title: "Confirm",
                                              middleText:
                                                  "Are you sure you want to submit?",
                                              textConfirm: "Confirm",
                                              textCancel: "Back",
                                              confirmTextColor: whiteColor,
                                              cancelTextColor:
                                                  primaryThemeColor,
                                              radius: 0,
                                              onCancel: () {
                                                return;
                                              },
                                              onConfirm: () {
                                                quizSubmit();
                                                return;
                                              });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ));
                }),

            // draggable scrollable widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DraggableScrollableSheet(
                  minChildSize: 0.070,
                  initialChildSize: 0.070,
                  maxChildSize: 0.4,
                  builder: (BuildContext context, listScrollControl) {
                    return Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.pink.shade900.withOpacity(0.5),
                                blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: ListView.builder(
                        controller: listScrollControl,
                        itemCount: questions.length,
                        itemBuilder: (BuildContext context, int index) {
                          var question = questions[index];
                          var questionWrap = Wrap();
                          if (question['lateX']) {
                            final longEq = Math.tex(
                              question['quesText'],
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            );
                            final breakResult = longEq.texBreak();
                            questionWrap = Wrap(
                              children: breakResult.parts,
                            );
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  primaryDarkThemeColor.withAlpha(170),
                              child: FittedBox(
                                  child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor),
                              )),
                            ),
                            onTap: () {
                              _pageController.jumpToPage(index);
                            },
                            title: !questions[index]['lateX']
                                ? Text(
                                    '${questions[index]['quesText']}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  )
                                : questionWrap,
                          );
                        },
                      ),
                    );
                  }),
            )
          ],
        )));
  }
}
