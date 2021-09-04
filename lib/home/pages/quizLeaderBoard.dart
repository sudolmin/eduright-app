import 'package:eduapp/globals.dart';
import 'package:eduapp/home/controller/home_contant.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QLeaderBoard extends StatelessWidget {
  const QLeaderBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map dataMap = Get.arguments;
    return Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text(
                      "LEADERBOARD",
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: GoogleFonts.alfaSlabOne().fontFamily,
                          shadows: [
                            Shadow(
                                color: Colors.blueGrey.shade100,
                                blurRadius: 10,
                                offset: Offset(4, 4))
                          ]),
                    ),
                    Text(
                      "(${dataMap["quizName"]})",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: FutureBuilder(
                      future: handleMarksData('${dataMap["quizSlug"]}'),
                      builder: (context, AsyncSnapshot<Map> marklistSnapshot) {
                        if (marklistSnapshot.connectionState ==
                                ConnectionState.none &&
                            marklistSnapshot.hasData == false) {
                          return Container();
                        }
                        if (marklistSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Image.asset("assets/images/rank.png")),
                              SizedBox(
                                child: Center(
                                    child: CupertinoActivityIndicator(
                                  radius: 20,
                                )),
                              ),
                            ],
                          );
                        }
                        final marksData = marklistSnapshot.data;
                        final marksList = marksData!["markModel_quizset"];
                        final profileDetail = marksData["profile"];
                        String name = profileDetail['fullname'];
                        int rank = 1;
                        List<int> rankList = [];
                        for (var i = 0; i < marksList.length; i++) {
                          var mEle = marksList[i];
                          if (i != 0) {
                            var now = mEle["marksObtained"];
                            var prev = marksList[i - 1]["marksObtained"];
                            print("before inc");
                            print(rank);
                            if (now != prev) {
                              rank++;
                            }
                          }
                          rankList.add(rank);
                        }

                        return ListView.builder(
                            itemCount: marksList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var mEle = marksList[index];
                              rank = rankList[index];

                              TextStyle textstyle = TextStyle(
                                  color:
                                      rank <= 3 ? whiteColor : Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Container(
                                  height: rank <= 3 ? 70 : 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: name == mEle["student"]
                                          ? Border.all(color: primaryThemeColor)
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade500,
                                            offset: Offset(4, 4),
                                            blurRadius: 5)
                                      ],
                                      gradient: LinearGradient(
                                          colors: rank == 1
                                              ? firstrankGradient
                                              : rank == 2
                                                  ? secondrankGradient
                                                  : rank == 3
                                                      ? thirdrankGradient
                                                      : restRankGradient),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Text(
                                              // ignore: unnecessary_brace_in_string_interps
                                              "${rank}.",
                                              style: textstyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "${mEle["student"]}",
                                                style: textstyle,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "${mEle["marksObtained"]}",
                                          style: textstyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      })),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        primary: Color(0xFFE67DAC),
                        onSurface: Color(0xFFE67DAC),
                        fixedSize: Size(120, 50)),
                    onPressed: () {
                      Get.offAllNamed('/homeview');
                    },
                    child: Text("Goto Home"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
