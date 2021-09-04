import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../genericWidgets.dart';

class FlashCardTopic extends StatelessWidget {
  const FlashCardTopic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final unit = data['unit'];
    final unitname = unit['name'];
    final id = unit['id'];

    return Scaffold(
      appBar: genAppBar(unitname),
      body: FutureBuilder(
          future: getFlashTopics(id),
          builder: (context, AsyncSnapshot<List> topicListSnap) {
            if (topicListSnap.connectionState == ConnectionState.none &&
                topicListSnap.hasData == false) {
              return Container();
            }
            if (topicListSnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                ),
              );
            }
            final topicList = topicListSnap.data;
            return ListView.builder(
                itemCount: topicList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed("/flashcardlist",
                              arguments: topicList[index]);
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
                                    '${topicList[index]["name"]}',
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
