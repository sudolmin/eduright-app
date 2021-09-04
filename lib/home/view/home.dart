import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/home/view/classTab.dart';
import 'package:eduapp/home/view/flipcardTab.dart';
import 'package:eduapp/home/view/homeTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'accountTab.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    handleUpdates();
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    Hive.box(updateInfoBoxName).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(
              Icons.home_outlined,
              size: 30,
              color: bottomNavIconColor,
            ),
            Icon(
              Icons.blur_on_rounded,
              size: 30,
              color: bottomNavIconColor,
            ),
            Icon(
              Icons.content_copy_outlined,
              size: 30,
              color: bottomNavIconColor,
            ),
            Icon(
              Icons.perm_identity,
              size: 30,
              color: bottomNavIconColor,
            ),
          ],
          color: Colors.white,
          buttonBackgroundColor: bottomNavbuttonBackgroundColor,
          backgroundColor: bottomNavbackgroundColor,
          animationCurve: Curves.easeInToLinear,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
              _pageController.jumpToPage(_page);
            });
          },
          letIndexChange: (index) => true,
        ),
        body: PageView(
          /// [PageView.scrollDirection] defaults to [Axis.horizontal].
          /// Use [Axis.vertical] to scroll vertically.
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          onPageChanged: (pageIndex) {
            setState(() {
              final CurvedNavigationBarState? navBarState =
                  _bottomNavigationKey.currentState;
              navBarState?.setPage(pageIndex);
            });
          },
          children: <Widget>[
            HomeTab(),
            QuizTab(),
            FlipCardTab(),
            AccountTab(),
          ],
        ));
  }
}
