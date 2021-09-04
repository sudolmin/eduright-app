import 'package:eduapp/globals.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("About"),
          backgroundColor: Color(0xFFDD6090),
          toolbarHeight: 80),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(color: whiteColor, boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 3))
                  ]),
                  child: ListTile(
                    title: Text("Credits"),
                    onTap: () async {
                      if (await canLaunch(
                          "https://edurightinfo.web.app/credits.html")) {
                        launch("https://edurightinfo.web.app/credits.html");
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                    decoration: BoxDecoration(color: whiteColor, boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 3))
                    ]),
                    child: ListTile(
                        title: Text("Privacy Policy"),
                        onTap: () async {
                          if (await canLaunch(
                              "https://edurightinfo.web.app/privacy-policy.html")) {
                            launch(
                                "https://edurightinfo.web.app/privacy-policy.html");
                          }
                        })),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(color: whiteColor, boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 3))
                  ]),
                  child: ListTile(
                      title: Text("Team"),
                      onTap: () async {
                        if (await canLaunch(
                            "https://edurightinfo.web.app/developers.html")) {
                          launch(
                              "https://edurightinfo.web.app/developers.html");
                        }
                      }),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: 50,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Made with ",
                                    style: TextStyle(color: Color(0xFF2E2E2E)),
                                  ),
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    " in India.",
                                    style: TextStyle(color: Color(0xFF2E2E2E)),
                                  )
                                ],
                              ),
                              Text(
                                "Eduright 1.1.5 (2)",
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFF4E4E4E)),
                              ),
                            ]),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
