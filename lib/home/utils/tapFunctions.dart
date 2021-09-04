import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/quizController.dart';
import 'package:eduapp/home/models/profileInfoModel.dart';
import 'package:eduapp/login/utils/apiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

Future<Map> profile({mode = ""}) async {
  final profileBox = await Hive.openBox(profileInfoBoxName);
  final updateBox = Hive.box(updateInfoBoxName);
  var profileInfoMap = profileBox.get("profileInfo", defaultValue: null);

  var proMap = {};

  if (profileInfoMap == null ||
      updateBox.get(updateProfile_bool_Hkey) == true ||
      mode == "refresh") {
    final resp = await profileQuery();
    final proMapObj = resp['profileInfo'];
    List classListDyn = updateBox.get(classesListData_Hkey, defaultValue: []);
    List<String> classList = [];
    for (var cls in classListDyn) {
      classList.add(cls["class"]);
    }
    proMap = proMapObj;
    profileBox.put(
        "profileInfo",
        ProfileInfo(
            proMapObj['username'],
            proMapObj['fullname'],
            proMapObj['email'],
            proMapObj["standard"],
            classList,
            proMapObj['verified'],
            proMapObj["edustd"]));
    profileInfoMap = profileBox.get("profileInfo", defaultValue: null);
    updateBox.put(updateProfile_bool_Hkey, false);
  }
  return proMap; // data is enum can be accessed by instance.enum
}

Future profileDataUpdate(profileDataObj) async {
  print(profileDataObj);
  if (profileDataObj['standard'] == null) {
    profileDataObj['standard'] = "";
  }
  final resp = await profileUpdate(profileDataObj);
  print(resp);
  await profile(mode: "refresh");
  return resp;
}

Future accountDelete() async {
  final resp = await accountDelApi();
  return resp;
}

void settings() {
  Get.snackbar("Request Successful",
      "You are logged out of your account successfully. Redirecting you to SignUp page.",
      barBlur: 5);
}

Future logoutHandler() async {
  final resp = await logout();
  if (resp['logout'] == "true") {
    return true;
  }
  return false;
}

void handleUpdates() async {
  final updateBox = await Hive.openBox(updateInfoBoxName);

  var profilehash = updateBox.get(userDataMsgDigest_Hkey, defaultValue: null);
  var clsMsgDigest = updateBox.get(classesMsgDigest_Hkey, defaultValue: null);
  var subHashHive = updateBox.get(cateDataMsgDigest_Hkey, defaultValue: null);
  var bannerHashHive = updateBox.get(bannerDataHash_Hkey, defaultValue: null);
  var linkHashHive = updateBox.get(linkDataHash_Hkey, defaultValue: null);
  var infoHashHive = updateBox.get(infotabDataHash_Hkey, defaultValue: null);

  updateBox.put(updateProfile_bool_Hkey, true);
  updateBox.put(classesList_bool_Hkey, true);
  updateBox.put(cateList_bool_Hkey, true);
  updateBox.put(banner_bool_Hkey, true);
  updateBox.put(link_bool_Hkey, true);
  updateBox.put(infotab_bool_Hkey, true);

  Map resp = await checkHashes();
  if (bannerHashHive == resp['bannerDataMsgDigest']) {
    updateBox.put(banner_bool_Hkey, false);
  }
  if (linkHashHive == resp['linkDataMsgDigest']) {
    updateBox.put(link_bool_Hkey, false);
  }
  if (infoHashHive == resp['infoDataMsgDigest']) {
    updateBox.put(infotab_bool_Hkey, false);
  }
  if (profilehash == resp['userDataMsgDigest']) {
    updateBox.put(updateProfile_bool_Hkey, false);
  }
  if (clsMsgDigest == resp['classDataMsgDigest']) {
    updateBox.put(classesList_bool_Hkey, false);
  }
  if (subHashHive == resp['cateDataMsgDigest']) {
    updateBox.put(cateList_bool_Hkey, false);
  }
  updateBox.put(bannerDataHash_Hkey, resp['bannerDataMsgDigest']);
  updateBox.put(linkDataHash_Hkey, resp['linkDataMsgDigest']);
  updateBox.put(infotabDataHash_Hkey, resp['infoDataMsgDigest']);
  updateBox.put(userDataMsgDigest_Hkey, resp['userDataMsgDigest']);
  updateBox.put(classesMsgDigest_Hkey, resp['classDataMsgDigest']);
  updateBox.put(cateDataMsgDigest_Hkey, resp['cateDataMsgDigest']);
  classList();
}

Future<List> bannerList() async {
  final updateBox = await Hive.openBox(updateInfoBoxName);
  final hometabbox = await Hive.openBox(homeTabBoxName);

  var bannerListBool = updateBox.get(banner_bool_Hkey, defaultValue: true);

  List bannerLi = hometabbox.get(bannerListData_Hkey, defaultValue: []);

  if (bannerListBool) {
    bannerLi = await getBannersList();
    hometabbox.put(bannerListData_Hkey, bannerLi);
    updateBox.put(banner_bool_Hkey, false);
  }
  return bannerLi;
}

Future<List> linkList() async {
  final updateBox = await Hive.openBox(updateInfoBoxName);
  final hometabbox = await Hive.openBox(homeTabBoxName);

  var linkListBool = updateBox.get(link_bool_Hkey, defaultValue: true);

  List linkLi = hometabbox.get(linkListData_Hkey, defaultValue: []);

  if (linkListBool) {
    linkLi = await getLinkList();
    hometabbox.put(linkListData_Hkey, linkLi);
    updateBox.put(link_bool_Hkey, false);
  }
  return linkLi;
}

Future<List> infotabList() async {
  final updateBox = await Hive.openBox(updateInfoBoxName);
  final hometabbox = await Hive.openBox(homeTabBoxName);

  var infotabListBool = updateBox.get(infotab_bool_Hkey, defaultValue: true);

  List infoLis = hometabbox.get(infotabListData_Hkey, defaultValue: []);

  if (infotabListBool) {
    infoLis = await getInfoTabList();
    hometabbox.put(infotabListData_Hkey, infoLis);
    updateBox.put(infotab_bool_Hkey, false);
  }
  return infoLis;
}

Future<List> classList() async {
  final updateBox = await Hive.openBox(updateInfoBoxName);
  var classesListBool =
      updateBox.get(classesList_bool_Hkey, defaultValue: true);

  List classLi = updateBox.get(classesListData_Hkey, defaultValue: []);
  if (classesListBool) {
    Map classM = await classesQuery();
    List classLi = classM["classDList"];
    updateBox.put(classesListData_Hkey, classLi);
    updateBox.put(classesList_bool_Hkey, false);
  }
  return classLi;
}

// {
//     "categories": [
//         {
//             "title": "Physics",
//             "slug": "class-12-science_physics"
//         },
//         {
//             "title": "Chemistry",
//             "slug": "class-12-science_chemistry"
//         }
//     ]
// }
// ------------
//  Response format
Future<List> getCategories(className) async {
  final updateBox = await Hive.openBox(updateInfoBoxName);
  final categoryBox = await Hive.openBox(categoryBoxName);

  var subDataUpdate = updateBox.get(cateList_bool_Hkey, defaultValue: true);
  var cateList = categoryBox.get(className, defaultValue: null);

  if (cateList == null || subDataUpdate) {
    final resp = await subQuery(className);
    cateList = resp["categories"];
    categoryBox.put(className, cateList);
    updateBox.put(cateList_bool_Hkey, false);
  }

  return cateList;
}

Future<Map> handleQuizListQuery(subjectSlug) async {
  var respMap = await getQuizSets(subjectSlug);
  return respMap;
}

Future<Map> handleQuizData(String quizSlug) async {
  var respMap = await getQuizData(quizSlug);
  return respMap;
}

Future<Map> handleMarksData(quizSlug) async {
  var respMap = await getMarksList(quizSlug);
  final resp = await profileQuery();
  final proMapObj = resp['profileInfo'];
  respMap["profile"] = proMapObj;
  return respMap;
}
// quiz tap functions

Future quizSubmit() async {
  final quizController_g = Get.find<QuizController>();

  String quizName = quizController_g.quizName;
  String quizSlug = quizController_g.quizSlug;
  List<int> marksList = quizController_g.answerMarksList;

  int max_marks = quizController_g.max_marks;
  List questions = quizController_g.questions;

  int totalMarksScored =
      marksList.fold(0, (previousValue, num) => previousValue + num);

  Get.snackbar("Submitting Your Response", "Please Wait.");
  double percent = (totalMarksScored / max_marks) * 100;

  var imagePath = "";
  var performMessage = "";

  if (percent < 30) {
    imagePath = "assets/images/badperform.png";
    performMessage =
        "No neeed to worry, study harder and outperform yourself next time.";
  } else if (percent > 75) {
    imagePath = "assets/images/goodperform.png";
    performMessage = "Woohoo! Great attempt! Keep up with the good work.";
    if (percent > 90) {
      performMessage = "Yaay! I can see a genius in the making.";
    }
  } else {
    imagePath = "assets/images/needtowork.png";
    performMessage =
        "Good attempt kiddo! There's always room for improvement! Study hard.";
  }

  Map data = {
    'markScored': totalMarksScored.toString(),
    'outOf': max_marks.toString(),
    'percent': percent,
    "quizName": quizName,
    "quizSlug": quizSlug,
    "questions": questions,
    "imagePath": imagePath,
    "performMessage": performMessage,
    "selectMap": quizController_g.selectedIndexMap,
    "attempt": quizController_g.answerAttempts
  };

  final respMap = await submitQuiz(quizSlug, totalMarksScored);

  if (respMap['attempt saved'] == true) {
    quizController_g.submitted = true;
    Get.snackbar("Submitted your Quiz",
        "Please Wait while we redirect you to performance page.");
    await Future.delayed(Duration(seconds: 2));
    Get.offAllNamed("/quizcomplete", arguments: data);
  } else {
    Get.snackbar("Error",
        "An unexpected error has occurred. Please check your connectivity or Contact admin.",
        colorText: whiteColor, backgroundColor: Colors.red.shade600);
    return 0;
  }
}

// functions related to flashcards

Future<List> getFlashUnits(slug) async {
  final resp = await flashsubunits(slug);
  List unitlist = [];
  if (resp['code'] == "FU200") {
    unitlist = resp['unitlist'];
  } else {}
  return unitlist;
}

Future<List> getFlashTopics(id) async {
  final resp = await flashunittopics(id);
  List unitlist = [];
  if (resp['code'] == "FU200") {
    unitlist = resp['topiclist'];
  } else {}
  return unitlist;
}

Future<List> getFlashCards(id) async {
  final resp = await flashcards(id);
  List unitlist = [];
  if (resp['code'] == "FU200") {
    unitlist = resp['cardlist'];
  } else {}
  return unitlist;
}

Future likecard(id, mode) async {
  final resp = await flashlike(id, mode);
  return resp;
}

Future postflashcard(Map<String, dynamic> data, {update = false}) async {
  var resp;
  if (update) {
    resp = await flashpost(data, update);
  } else {
    resp = await flashpost(data, update);
  }

  return resp;
}

Future deleteFlashCard(Map<String, dynamic> data) async {
  final resp = await flashdelete(data);
  return resp;
}
