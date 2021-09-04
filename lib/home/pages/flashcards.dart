import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eduapp/genericWidgets.dart';
import 'package:eduapp/home/utils/flashcardcolors.dart';
import 'package:eduapp/home/utils/flashcardcontainer.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../globals.dart';

class FlashCards extends StatefulWidget {
  const FlashCards({Key? key}) : super(key: key);

  @override
  _FlashCardsState createState() => _FlashCardsState();
}

class _FlashCardsState extends State<FlashCards> {
  final data = Get.arguments;
  final profileBox = Hive.box(profileInfoBoxName);
  @override
  Widget build(BuildContext context) {
    final topicid = data["id"];
    final profileInfo = profileBox.get("profileInfo");
    final standard = profileInfo.standard;
    final username = profileInfo.username;
    final verified = profileInfo.verified;
    final edustd = profileInfo.stdateduright;
    return Scaffold(
        appBar: genAppBar(data['name']),
        floatingActionButton: verified || edustd
            ? InkWell(
                onTap: () {
                  Get.toNamed('/addflashcard', arguments: {
                    'mode': 'Add',
                    'topic': data['name'],
                    'topicid': topicid,
                    "addedby": username,
                    "edustd": edustd,
                    "verified": verified
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(1, 4),
                          blurRadius: 10)
                    ],
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: ButtonGradColors.btgradcolors[1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: Color(0xFF80383A),
                    ),
                  ),
                ),
              )
            : null,
        body: FutureBuilder(
            future: getFlashCards(topicid),
            builder: (context, AsyncSnapshot<List> cardsnapshot) {
              if (cardsnapshot.connectionState == ConnectionState.none &&
                  cardsnapshot.hasData == false) {
                return Container();
              }
              if (cardsnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                );
              }
              final cardList = cardsnapshot.data;

              final flashcardwidgetlist = cardList!.map((cardelement) {
                int randomInt = Random().nextInt(2);
                List colorlist = [];
                Color textColor;
                if (randomInt == 0) {
                  colorlist = FlashGradColors.darkColors;
                  textColor = Colors.white;
                } else {
                  colorlist = FlashGradColors.lightColors;
                  textColor = Colors.blueGrey.shade800;
                }
                int randomIndex = Random().nextInt(colorlist.length);
                return FlipCard(
                  front: FlashCardContainer(
                    data: {
                      'id': cardelement['id'],
                      'text': cardelement['front_Text'],
                      'latex': cardelement['front_LateX'],
                      'image': cardelement['front_image'],
                      'size': cardelement['front_size'],
                      "by": cardelement['addedby'],
                      'edustd': cardelement['edustd'],
                      'likes': cardelement['likes'],
                      'likedbyuser': cardelement['likedbyuser'],
                      //
                      'topic': data['name'],
                      'topicid': topicid,
                      "addedby": username,
                      "verified": verified,
                      "cardelement": cardelement
                    },
                    colors: colorlist[randomIndex],
                    textcolor: textColor,
                    front: true,
                    edit: username == cardelement['addedby'],
                    update: () {
                      setState(() {});
                    },
                  ),
                  back: FlashCardContainer(
                    data: {
                      'text': cardelement['back_Text'],
                      'latex': cardelement['back_LateX'],
                      'image': cardelement['back_image'],
                      'size': cardelement['back_size'],
                      'likes': cardelement['likes'],
                      'likedbyuser': false
                    },
                    colors: colorlist[randomIndex],
                    textcolor: textColor,
                  ),
                );
              }).toList();

              return Container(
                height: double.infinity,
                child: CarouselSlider(
                  options: CarouselOptions(
                      scrollDirection: Axis.vertical,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false),
                  items: flashcardwidgetlist,
                ),
              );
            }));
  }
}
