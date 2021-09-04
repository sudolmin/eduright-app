import 'package:cached_network_image/cached_network_image.dart';
import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    return Scaffold(
      appBar: genAppBar(data),
      body: FutureBuilder(
          future: getCategories(data),
          builder: (context, AsyncSnapshot subListSnap) {
            if (subListSnap.connectionState == ConnectionState.none &&
                subListSnap.hasData == false) {
              return Container();
            }
            if (subListSnap.connectionState == ConnectionState.waiting) {
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemCount: subs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        Get.toNamed("/quizlistview",
                            arguments: {"sub": subs[index], "class": data});
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
                                  imageUrl: "http://20.204.50.144/" +
                                      subs[index]["icon"],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      backgroundColor:
                                          primaryDarkThemeColor.withAlpha(40),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
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
    );
  }
}
