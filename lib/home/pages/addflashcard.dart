import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/home/controller/flashaddcontroller.dart';
import 'package:eduapp/home/utils/addflashside.dart';
import 'package:eduapp/home/utils/flashcardcolors.dart';
import 'package:eduapp/home/utils/flashcardcontainer.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../globals.dart';

class AddFlashCard extends StatefulWidget {
  const AddFlashCard({Key? key}) : super(key: key);

  @override
  _AddFlashCardState createState() => _AddFlashCardState();
}

class _AddFlashCardState extends State<AddFlashCard> {
  final data = Get.arguments;
  FlashAddController fladdcont = Get.put(FlashAddController());

  @override
  Widget build(BuildContext context) {
    if (fladdcont.text['front'] == "" &&
        fladdcont.text['back'] == "" &&
        data['mode'] == "Edit") {
      print(data);
      fladdcont.text['front'] = data["initdata"]['front_Text'];
      fladdcont.latex['front'] = data["initdata"]['front_LateX'];
      fladdcont.text['back'] = data["initdata"]['back_Text'];
      fladdcont.latex['back'] = data["initdata"]['back_LateX'];
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              indicatorColor: whiteColor,
              indicatorWeight: 4,
              tabs: [
                Tab(
                  text: "Front",
                ),
                Tab(
                  text: "Back",
                ),
                Tab(
                  text: "Preview",
                ),
              ],
            ),
            title: Text('${data['mode']} Flash Card-${data['topic']}'),
            shadowColor: Color(0x00000000),
            backgroundColor: Color(0x00000000),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color(0xFF9E5878), blurRadius: 10)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.3,
                        1
                      ],
                      colors: <Color>[
                        primaryThemeColor.withGreen(140),
                        Color(0xFFE67DAC),
                      ])),
            )),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TabBarView(
            children: [
              AddFlashSides(
                data: {"side": "front", "label": "Front Side Text"},
              ),
              AddFlashSides(
                data: {"side": "back", "label": "Back Side Text"},
              ),
              SingleChildScrollView(
                child: GetBuilder<FlashAddController>(builder: (_fl) {
                  return Column(
                    children: [
                      Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: FlipCard(
                          front: FlashCardContainer(
                              data: {
                                'id': 0,
                                'text': _fl.text['front'],
                                'latex': _fl.latex['front'],
                                'image': "",
                                "by": data['addedby'],
                                'edustd': data['edustd'],
                                'likes': data['mode'] == "Edit"
                                    ? data["initdata"]['likes']
                                    : 0,
                                'likedbyuser': data['mode'] == "Edit"
                                    ? data["initdata"]['likedbyuser']
                                    : false,
                              },
                              sizefactor: 0.70,
                              colors: FlashGradColors.darkColors[8],
                              textcolor: Color(0xFFFFEBC6),
                              front: true,
                              addPage: true),
                          back: FlashCardContainer(
                              data: {
                                'text': _fl.text['back'],
                                'latex': _fl.latex['back'],
                                'image': "",
                                'likes': 0,
                                'likedbyuser': false
                              },
                              colors: FlashGradColors.darkColors[8],
                              textcolor: Color(0xFFFFEBC6),
                              addPage: true),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_fl.text['front'] != "" &&
                                _fl.text['back'] != "") {
                              Get.snackbar("Processing Your Request",
                                  "Please Wait while we process ");
                              final res = await postflashcard({
                                'topicid': data['topicid'],
                                'flashid': data['mode'] == "Edit"
                                    ? data["initdata"]['id']
                                    : 0,
                                'front_Text': _fl.text['front'],
                                'front_LateX': _fl.latex['front'],
                                'back_Text': _fl.text['back'],
                                'back_LateX': _fl.latex['back']
                              }, update: data['mode'] == "Edit");

                              if (data['mode'] == "Edit") {
                                print("back");
                                Get.back();
                                Get.back();
                                final upfunc = data["updatefunc"];
                                upfunc();
                              } else {
                                _fl.init();
                                setState(() {});
                                final upfunc = data["update"];
                                upfunc();
                              }
                              Get.snackbar(
                                  "Request Completed", res['response']);
                            } else {
                              Get.snackbar("Error procesing your request",
                                  "Text Fields should not be empty. Please Check for empty field.");
                            }
                          },
                          child: Text(
                              data['mode'] == "Edit" ? "Update" : "Submit"))
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
