import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../genericWidgets.dart';

class FlashCardUnits extends StatelessWidget {
  const FlashCardUnits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final subject = data['sub'];
    final slug = subject['slug'];

    return Scaffold(
      appBar: genAppBar(subject['title']),
      body: FutureBuilder(
          future: getFlashUnits(slug),
          builder: (context, AsyncSnapshot<List> unitListSnap) {
            if (unitListSnap.connectionState == ConnectionState.none &&
                unitListSnap.hasData == false) {
              return Container();
            }
            if (unitListSnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            }
            final unitList = unitListSnap.data;
            return ListView.builder(
                itemCount: unitList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed("/flashcardtopic",
                              arguments: {"unit": unitList[index]});
                        },
                        child: Container(
                          constraints: BoxConstraints(minHeight: 60),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(fontSize: 18),
                                      ))),
                              Expanded(
                                  flex: 7,
                                  child: Text(
                                    '${unitList[index]["name"]}',
                                    style: TextStyle(fontSize: 18),
                                  )),
                            ],
                          ),
                        ),
                      ));
                });
          }),
    );
  }
}
