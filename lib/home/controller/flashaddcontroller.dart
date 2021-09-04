import 'package:get/get.dart';

class FlashAddController extends GetxController {
  Map<String, String?> text = {"front": "", "back": ""};
  Map<String, bool> latex = {"front": false, "back": false};

  void init() {
    text = {"front": "", "back": ""};
    latex = {"front": false, "back": false};
  }
}
