import 'dart:async';

import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class QuizController extends GetxController {
  Map selectedIndexMap = {};
  List<int> answerMarksList = [];
  // List<int> answerIndexList = [];
  List<String> answerAttempts = [];
  List<int> answerSelected = [];
  String quizName = "";
  String quizSlug = "";
  int max_marks = 0;
  int mark_per_question = 0;
  int negative_marking = 0;
  bool submitted = false;

  List questions = [];

  void increment(quesIndex) {
    answerMarksList[quesIndex] = mark_per_question;
    answerAttempts[quesIndex] = "correct";
  }

  void decrement(quesIndex) {
    answerMarksList[quesIndex] = -negative_marking;
    answerAttempts[quesIndex] = "incorrect";
  }

  void reset(quesIndex) {
    answerMarksList[quesIndex] = 0;
    answerAttempts[quesIndex] = "unattempted";
  }

  int timerLeft = 0;

  void countdown({mode = "init", caller = "timesup"}) {
    Timer.periodic(Duration(seconds: 1), (timerObj) async {
      if (mode == "dispose" || timerLeft == 0) {
        timerObj.cancel();
        if (caller == "timesup" && mode != "dispose" && !submitted) {
          quizSubmit();
        }
      } else {
        timerLeft--;
        update();
      }
    });
  }
}
