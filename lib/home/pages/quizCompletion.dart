import 'package:eduapp/globals.dart';
import 'package:eduapp/home/widget/shapes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';

class QCompletion extends StatelessWidget {
  const QCompletion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: CustomPaint(
                painter: CircleIndicator(data['percent']),
                child: Container(
                  height: 180,
                  width: 180,
                  child: Center(
                    child: Text(
                      "${data['markScored']}/${data['outOf']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            Image.asset(data["imagePath"]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  data["performMessage"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ExpansionTile(
                title: Text(
                  "See Solutions",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data['questions'].length,
                      itemBuilder: (BuildContext context, int index) {
                        var quesEle = data['questions'][index];
                        String question = quesEle['quesText'];
                        var answers = quesEle['answers'];
                        int quesIndex = index;
                        var questionWrap = Wrap();
                        if (quesEle['lateX']) {
                          final longEq = Math.tex(
                            question,
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          );
                          final breakResult = longEq.texBreak();
                          questionWrap = Wrap(
                            children: breakResult.parts,
                          );
                        }
                        return ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                data["attempt"][index] == "unattempted"
                                    ? Colors.blue.shade200
                                    : data["attempt"][index] == "correct"
                                        ? Colors.green.shade200
                                        : Colors.red.shade300,
                            child: FittedBox(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          title:
                              !quesEle['lateX'] ? Text(question) : questionWrap,
                          subtitle: quesEle['imageOption'] != null
                              ? Container(
                                  constraints: BoxConstraints(
                                      maxHeight: quesEle['imageHeight'] * 1.0),
                                  child: Image.network(
                                      '${quesEle['imageQuestion']}'),
                                )
                              : null,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: answers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var answerEle = answers[index];
                                  var answerWrap = Wrap();
                                  if (answerEle['lateX']) {
                                    final longEq = Math.tex(
                                      answerEle['option'],
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
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black12))),
                                    child: ListTile(
                                      leading: answerEle["correct"]
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade400,
                                            )
                                          : Icon(
                                              Icons.cancel,
                                              color: Colors.red.shade400,
                                            ),
                                      title: !answerEle['lateX']
                                          ? Text("${answerEle["option"]}")
                                          : answerWrap,
                                      subtitle: answerEle['imageOption'] != null
                                          ? Container(
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      answerEle['imageHeight'] *
                                                          1.0),
                                              child: Image.network(
                                                  '${answerEle['imageOption']}'),
                                            )
                                          : null,
                                      trailing: data['selectMap'][quesIndex] ==
                                              index
                                          ? Text(
                                              "(Your Choice)",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: primaryThemeColor,
                                                  fontSize: 12),
                                            )
                                          : null,
                                    ),
                                  );
                                })
                          ],
                        );
                      })
                ],
              ),
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(120, 50),
                  ),
                  onPressed: () {
                    Get.offAllNamed('/quizleaderboard', arguments: {
                      "quizName": data["quizName"],
                      "quizSlug": data["quizSlug"]
                    });
                  },
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(fontSize: 17),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
