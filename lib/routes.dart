import 'package:eduapp/home/pages/about.dart';
import 'package:eduapp/home/pages/addflashcard.dart';
import 'package:eduapp/home/pages/categoryView.dart';
import 'package:eduapp/home/pages/flashcards.dart';
import 'package:eduapp/home/pages/topics.dart';
import 'package:eduapp/home/pages/quizCompletion.dart';
import 'package:eduapp/home/pages/quizIntro.dart';
import 'package:eduapp/home/pages/quizLeaderBoard.dart';
import 'package:eduapp/home/pages/quizList.dart';
import 'package:eduapp/home/view/home.dart';
import 'package:eduapp/login/view/signin.dart';
import 'package:eduapp/login/view/signup.dart';
import 'package:get/get.dart';

import 'home/pages/unit.dart';
import 'home/pages/profileInfo.dart';
import 'home/pages/quizPage.dart';
import 'login/view/signMain.dart';

final List<GetPage<dynamic>> routeMap = [
  GetPage(
      name: '/signmainpage',
      page: () => SignPage(),
      transition: Transition.downToUp,
      transitionDuration: Duration(seconds: 1)),
  GetPage(
    name: '/signinpage',
    page: () => SignInPage(),
    transition: Transition.leftToRightWithFade,
  ),
  GetPage(
      name: '/signuppage',
      page: () => SignUpPage(),
      transition: Transition.rightToLeftWithFade),
  GetPage(
      name: '/homeview',
      page: () => HomeView(),
      transition: Transition.cupertino,
      transitionDuration: Duration(seconds: 1)),
  GetPage(
      name: '/categoryview',
      page: () => CategoryView(),
      transition: Transition.cupertino),
  GetPage(
      name: '/profileinfo',
      page: () => ProfileInfoView(),
      transition: Transition.fadeIn),
  GetPage(
      name: '/about',
      page: () => AboutView(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/quizlistview',
      page: () => QuizListView(),
      transition: Transition.rightToLeftWithFade),
  GetPage(
      name: '/quizstartintro',
      page: () => QuizIntro(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/quizpage',
      page: () => QuizPage(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/quizcomplete',
      page: () => QCompletion(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/quizleaderboard',
      page: () => QLeaderBoard(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/units', page: () => Units(), transition: Transition.rightToLeft),
  GetPage(
      name: '/topics',
      page: () => Topics(),
      transition: Transition.rightToLeft),
  GetPage(
      name: '/flashcardlist',
      page: () => FlashCards(),
      transition: Transition.rightToLeft),
  GetPage(
    name: '/addflashcard',
    page: () => AddFlashCard(),
    transition: Transition.cupertino,
  ),
];
