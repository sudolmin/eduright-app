import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/widgets.dart';
import 'package:eduapp/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // const double tileradius = 12;
    // List<BoxShadow> tileBoxShadowList = [
    //   BoxShadow(offset: Offset(0, 4), blurRadius: 10, color: Color(0x93A1A1A1))
    // ];
    return Scaffold(
      backgroundColor: pagesBackgroundColor,
      appBar: genAppBar("Home"),
      body: ListView(
        children: [
          FutureBuilder(
              future: BannerSliders(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == false) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 150,
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  );
                }
                Widget banners = snapshot.data!;
                return banners;
              }),
          sizeBox(5),
          FutureBuilder(
              future: InfoTabs(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == false) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 150,
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  );
                }
                Widget banners = snapshot.data!;
                return banners;
              }),
          sizeBox(12),
          FutureBuilder(
              future: LinkGrid(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == false) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      height: 150,
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  );
                }
                Widget banners = snapshot.data!;
                return banners;
              }),
          sizeBox(30),
        ],
      ),
    );
  }
}
