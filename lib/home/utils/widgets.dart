import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/profileController.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

Widget profiletextfield(String label, MultiValidator validators,
    {IconData iconData = Icons.not_interested_sharp,
    Color focusColor = primaryThemeColor,
    Color labelColor = primaryThemeColor,
    String field = "",
    initialValue = "",
    readonly = false}) {
  final profileCont = Get.find<ProfileController>();
  return Padding(
    padding: const EdgeInsets.all(12),
    child: TextFormField(
        style: TextStyle(color: focusColor, fontSize: 18),
        key: Key(field),
        readOnly: readonly,
        onChanged: (str) {
          profileCont.updateButtonEnabled = true;

          switch (field) {
            case "email":
              profileCont.email = str;
              break;
            case "fullName":
              profileCont.fullName = str;
              break;
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validators, // validators.dart
        initialValue: initialValue,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: labelColor, fontSize: 18),
            prefixIcon: Icon(
              iconData,
              color: labelColor,
            ),
            focusColor: focusColor,
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: focusColor)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: focusColor))),
        keyboardType:
            field == "email" ? TextInputType.emailAddress : TextInputType.text),
  );
}

ElevatedButton elevatedButton(
    String text, Function onPressFunc, Color textColor, Color surfaceColor,
    {fontsize = signBtnFontSize_G, btnBorderColor = primaryThemeColor}) {
  return ElevatedButton(
    onPressed: () {
      onPressFunc();
    },
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: fontsize),
    ),
    style: ElevatedButton.styleFrom(
      primary: surfaceColor,
      side: BorderSide(width: 2.0, color: btnBorderColor),
      onSurface: surfaceColor,
      minimumSize: buttonSize,
    ),
  );
}

ElevatedButton progressButton(Color indiolor, Color surfaceColor) {
  return ElevatedButton(
    onPressed: () {
      print("");
    },
    child: CircularProgressIndicator(
      color: indiolor,
    ),
    style: ElevatedButton.styleFrom(
      primary: surfaceColor,
      side: BorderSide(width: 2.0, color: primaryThemeColor),
      onSurface: surfaceColor,
      minimumSize: buttonSize,
    ),
  );
}

// Hometab component widgets
Future<Widget> BannerSliders() async {
  await bannerList();
  final hometabbox = Hive.box(homeTabBoxName);

  List bannerLi = hometabbox.get(bannerListData_Hkey, defaultValue: []);

  List<Widget> items = [];

  for (var obj in bannerLi) {
    items.add(Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: CachedNetworkImage(
        imageUrl: obj["image"],
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          height: 60,
          width: 60,
          child: Container(
            color: Colors.blueGrey.shade50,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ));
  }

  return Container(
    height: 150,
    child: CarouselSlider(
      options: CarouselOptions(
        height: 140.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: false,
        autoPlayAnimationDuration: Duration(milliseconds: 2500),
        viewportFraction: 0.6,
      ),
      items: items,
    ),
  );
}

Future<Widget> InfoTabs() async {
  List infoLi = await infotabList();
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: infoLi.length,
        itemBuilder: (context, index) {
          return Container(
            // constraints: BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 6),
                      blurRadius: 10)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: infoLi[index]["icon"],
                        height: 30,
                        width: 30,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            backgroundColor:
                                primaryDarkThemeColor.withAlpha(40),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Center(
                        child: Text(
                          infoLi[index]["title"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${infoLi[index]["content"]}",
                      style: TextStyle(color: standardBlack),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
  );
}

Future<Widget> LinkGrid() async {
  final linkLi = await linkList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Container(
      // constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 6), blurRadius: 10)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.arrow_turn_up_right,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Important Links",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: linkLi.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      String url = linkLi[index]['url'];
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    child: GridTile(
                        footer: Center(
                            child: Text(linkLi[index]['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: standardBlack,
                                ))),
                        child: Container(
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: CachedNetworkImage(
                                imageUrl: linkLi[index]["icon"],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    backgroundColor:
                                        primaryDarkThemeColor.withAlpha(40),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ))),
                  );
                }),
          ],
        ),
      ),
    ),
  );
}
