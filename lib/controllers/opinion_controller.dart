import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test1/services/remote_services.dart';

class OpinionController extends GetxController {
  late int myRate;

  bool hasAlreadyRated = false;

  bool isLoading = false;
  void setLoading(bool val) {
    isLoading = val;
    update();
  }

  //todo: put them all in product controller and reset comment and evaluation after closing
}
