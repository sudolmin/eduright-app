import 'package:eduapp/globals.dart';
import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({
    Key? key,
    required this.leadIcon,
    required this.title,
    this.titleTextColor = Colors.black54,
    required this.bgcolor,
    required this.contradius,
    required this.onTapFunc,
    this.verPad = 8.0,
    this.contHeight,
    this.leadIconColor,
    this.inkSplashColor,
  }) : super(key: key);

  final IconData leadIcon;
  final String title;
  final Color titleTextColor;
  final Color bgcolor;
  final double? contHeight;
  final double contradius;
  final Color? leadIconColor;
  final Color? inkSplashColor;
  final Function onTapFunc;
  final double verPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: this.verPad),
      child: Material(
        color: whiteColor,
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(contradius)),
        shadowColor: Colors.black.withOpacity(0.3),
        child: InkWell(
          onTap: () {
            onTapFunc();
          },
          splashColor: this.inkSplashColor,
          child: Container(
            height: contHeight,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    this.leadIcon,
                    size: 30,
                    color: this.leadIconColor,
                  ),
                ),
                Text(
                  this.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: this.titleTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizSummaryRow extends StatelessWidget {
  const QuizSummaryRow(
      {Key? key,
      this.title = "",
      this.value,
      this.color = const Color(0xFF353535)})
      : super(key: key);

  final String title;
  final value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        value == null
            ? Text("Not Provided")
            : Text(
                value.toString(),
                style: TextStyle(color: color),
              )
      ],
    );
  }
}

AppBar genAppBar(title, {double btRad = 25}) {
  return AppBar(
      toolbarHeight: 80,
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 10,
      shadowColor: Color(0x00000000),
      backgroundColor: Color(0x00000000),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0xFF9E5878), blurRadius: 10)],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(btRad),
              bottomRight: Radius.circular(btRad),
            ),
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
      ));
}

// Gradient snackbarGradient() {
//   return SweepGradient(
//     center: FractionalOffset.center,
//     startAngle: 0.0,
//     colors: <Color>[
//       primaryThemeColor.withGreen(160),
//       Color(0xFFE67DAC),
//     ],
//     stops: <double>[0.25, 1.0],
//   );
// }
