import 'package:eduapp/home/controller/flashaddcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFlashSides extends StatefulWidget {
  final data;

  const AddFlashSides({Key? key, this.data}) : super(key: key);

  @override
  _AddFlashSidesState createState() => _AddFlashSidesState();
}

class _AddFlashSidesState extends State<AddFlashSides>
    with AutomaticKeepAliveClientMixin<AddFlashSides> {
  String? text;

  @override
  bool get wantKeepAlive => true;

  FlashAddController fladdcont = Get.find<FlashAddController>();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final data = this.widget.data;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    TextStyle _textStyle = TextStyle(fontSize: 16);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  maxLines: null,
                  initialValue: fladdcont.text[data['side']],
                  onChanged: (str) {
                    fladdcont.text[data['side']] = str;
                  },
                  decoration: InputDecoration(
                      labelText:
                          data['side'] == "front" ? "Front Side" : "Back Side",
                      labelStyle: TextStyle(
                          color: Colors.blueGrey.shade600, fontSize: 18),
                      focusColor: Colors.blueGrey.shade600,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade600)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade600)))),
              Row(children: [
                Text("Latex", style: _textStyle),
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: fladdcont.latex[data['side']],
                  onChanged: (bool? value) {
                    setState(() {
                      fladdcont.latex[data['side']] = value!;
                    });
                  },
                )
              ])
            ],
          )),
    );
  }
}
