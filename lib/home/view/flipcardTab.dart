import 'package:cached_network_image/cached_network_image.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../genericWidgets.dart';

class FlipCardTab extends StatelessWidget {
  const FlipCardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pagesBackgroundColor,
      appBar: genAppBar("Flash Cards"),
      body: Container(
        child: FutureBuilder(
            future: profile(),
            builder: (context, flashsnapshot) {
              if (flashsnapshot.connectionState == ConnectionState.none &&
                  flashsnapshot.hasData == false) {
                return Container();
              }
              if (flashsnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                );
              }
              final profileBox = Hive.box(profileInfoBoxName);
              final profileInfo = profileBox.get("profileInfo");
              final standard = profileInfo.standard;

              return Column(
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      profileInfo.standard,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                      future: getCategories(standard),
                      builder: (context, AsyncSnapshot subListSnap) {
                        if (subListSnap.connectionState ==
                                ConnectionState.none &&
                            subListSnap.hasData == false) {
                          return Container();
                        }
                        if (subListSnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                            ),
                          );
                        }
                        final subs = subListSnap.data!;
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              itemCount: subs.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed("/units", arguments: {
                                      "sub": subs[index],
                                      "class": standard,
                                      "mode": "flash"
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 8,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "http://20.204.50.144/" +
                                                      subs[index]["icon"],
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                  backgroundColor:
                                                      primaryDarkThemeColor
                                                          .withAlpha(40),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                          Flexible(
                                              flex: 2,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  subs[index]['title'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xC7000000),
                                                      fontSize: 15),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                ],
              );
            }),
      ),
    );
  }
}
