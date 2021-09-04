import 'package:cached_network_image/cached_network_image.dart';
import 'package:eduapp/home/utils/tapFunctions.dart';
import 'package:eduapp/login/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FlashCardContainer extends StatefulWidget {
  final List<Color> colors;
  final double minheight;
  final Color textcolor;
  final data;
  final bool front;
  final bool edit;
  final double sizefactor;
  final void Function()? update;

  FlashCardContainer(
      {Key? key,
      required this.data,
      required this.colors,
      required this.textcolor,
      this.update,
      this.minheight = 200,
      this.front = false,
      this.edit = false,
      this.sizefactor = 1.0})
      : super(key: key);

  @override
  _FlashCardContainerState createState() => _FlashCardContainerState(
      liked: this.data["likedbyuser"], likes: this.data["likes"]);
}

class _FlashCardContainerState extends State<FlashCardContainer> {
  bool liked;
  int likes;
  bool showlott = false;

  _FlashCardContainerState({required this.liked, required this.likes});

  @override
  Widget build(BuildContext context) {
    var contentWrap = Wrap();
    if (widget.data['latex']) {
      final longEq = Math.tex(
        widget.data["text"],
        textStyle: TextStyle(
          fontSize: 20,
          color: widget.textcolor,
        ),
      );
      final breakResult = longEq.texBreak();
      contentWrap = Wrap(
        children: breakResult.parts,
      );
    }
    print(widget.data);
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(minHeight: widget.minheight),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, offset: Offset(1, 4), blurRadius: 20)
            ],
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
            )),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: widget.data["image"] == null
                  ? Container(
                      alignment: Alignment.center,
                      child: widget.data['latex']
                          ? contentWrap
                          : Text(
                              widget.data["text"],
                              style: TextStyle(
                                  color: widget.textcolor, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !widget.data['latex']
                            ? Text(
                                '${widget.data['text']}',
                                style: TextStyle(
                                    color: widget.textcolor, fontSize: 18),
                              )
                            : contentWrap,
                        Container(
                          constraints: BoxConstraints(
                              maxHeight: widget.data['size'] * 1.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://20.204.50.144/" + widget.data['image'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                backgroundColor:
                                    Colors.blueGrey.shade600.withAlpha(40),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      ],
                    ),
            ),
            widget.front
                ? Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blueGrey.shade800, Colors.black54],
                          )),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: showlott && liked
                                ? Lottie.asset('assets/lottie/like.json',
                                    height: 60 * this.widget.sizefactor)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30 * this.widget.sizefactor,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          iconSize: 30 * this.widget.sizefactor,
                                          onPressed: () {
                                            setState(() {
                                              showlott = !showlott;
                                            });
                                            setState(() {
                                              if (!liked) {
                                                likes += 1;
                                                if (widget.data['id'] != 0) {
                                                  likecard(widget.data['id'],
                                                      'like');
                                                }
                                              } else {
                                                likes -= 1;
                                                if (widget.data['id'] != 0) {
                                                  likecard(widget.data['id'],
                                                      'dislike');
                                                }
                                              }
                                              liked = !liked;
                                            });
                                            Future.delayed(
                                                Duration(milliseconds: 2000),
                                                () {
                                              setState(() {
                                                showlott = !showlott;
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            this.liked
                                                ? Icons.favorite
                                                : Icons
                                                    .favorite_border_outlined,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$likes',
                                        style: TextStyle(
                                            fontSize: 13, color: whiteColor),
                                      )
                                    ],
                                  ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "by ${widget.data['by']}",
                                        style: TextStyle(
                                            fontSize: 14, color: whiteColor),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: Icon(
                                          Icons.verified_rounded,
                                          color: widget.data['edustd']
                                              ? Colors.pink.shade300
                                              : Colors.blue.shade400,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          this.widget.edit
                              ? IconButton(
                                  onPressed: () async {
                                    // this.widget.update!();
                                    await Get.defaultDialog(
                                      title: "Choose Your Action",
                                      middleText:
                                          "If you wish to edit, you'll be taken to the editing page.",
                                      actions: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Get.toNamed('/addflashcard',
                                                arguments: {
                                                  'mode': 'Edit',
                                                  'topic': widget.data['topic'],
                                                  'topicid':
                                                      widget.data['topicid'],
                                                  "addedby":
                                                      widget.data['addedby'],
                                                  "edustd":
                                                      widget.data['edustd'],
                                                  "verified":
                                                      widget.data['verified'],
                                                  "initdata": widget
                                                      .data["cardelement"],
                                                  "updatefunc":
                                                      this.widget.update
                                                });
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "I want to edit this card.",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await Get.defaultDialog(
                                                title: "Review Your Action",
                                                middleText:
                                                    "The following action is irreversible, this will delete this flashcard. Continue?",
                                                textConfirm: "Yes, I'm sure.",
                                                textCancel: "No, take me back",
                                                confirmTextColor: Colors.white,
                                                cancelTextColor:
                                                    Colors.blueGrey.shade700,
                                                radius: 0,
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                  return;
                                                },
                                                onConfirm: () async {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  final resp =
                                                      await deleteFlashCard({
                                                    'flashid': widget.data['id']
                                                  });

                                                  Get.snackbar(
                                                      "Request Completed",
                                                      resp['response']);
                                                  widget.update!();
                                                  return;
                                                });
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "I want to delete this card.",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color:
                                                          Colors.blue.shade400,
                                                      width: 2)),
                                              child: Text(
                                                "Nevermind, take me back.",
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade400),
                                              )),
                                        ),
                                      ],
                                    );
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    color: Color(0xFFFFEBC6),
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
