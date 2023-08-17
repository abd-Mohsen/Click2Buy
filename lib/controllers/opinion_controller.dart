import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OpinionController extends GetxController {
  final TextEditingController commentController = TextEditingController();

  late int myRate;

  bool hasAlreadyRated = false;

  bool isLoading = false;
  void setLoading(bool val) {
    isLoading = val;
    update();
  }

  Future<void> check() async {
    //
  }

  Future<void> submit() async {
    //hasAlreadyRated ? : ;
  }
}
