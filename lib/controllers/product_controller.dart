import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/product_model.dart';
import 'package:test1/models/variant_model1.dart';
import 'package:test1/services/remote_services.dart';

class ProductController extends GetxController {
  ProductController({required this.product});

  final GetStorage _getStorage = GetStorage();

  int myRate = 0;

  final TextEditingController commentController = TextEditingController();

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  late List<bool> selected = List.generate(product.variants.length, (i) => false);

  late VariantModel1? _selectedVariant;
  VariantModel1? get selectedVariant => _selectedVariant;

  final ProductModel product;

  late String _currentPicUrl = product.photos[0];
  String get currentPicUrl => _currentPicUrl;

  void changeVariant(VariantModel1 variant, int i) {
    _currentPicUrl = variant.image == "not found" ? product.photos[0] : variant.image;
    _selectedVariant = variant;
    _isSelected = true;
    for (int j = 0; j < selected.length; j++) {
      selected[j] = false;
    }
    selected[i] = true;
    update();
  }

  void addToWishlist() async {
    try {
      if (await RemoteServices.addToWishlist(_getStorage.read("token"), product.id).timeout(kTimeOutDuration3)) {
        Get.showSnackbar(GetSnackBar(
          messageText: Text(
            "added to wishlist".tr,
            textAlign: TextAlign.center,
            style: kTextStyle14.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.grey.shade800,
          duration: const Duration(milliseconds: 1000),
          borderRadius: 30,
          maxWidth: 150,
          margin: const EdgeInsets.only(bottom: 50),
        ));
      }
    } on TimeoutException {
      kTimeOutDialog();
    } catch (e) {
      print(e.toString());
    } finally {
      //
    }
  }

  Future<void> giveOpinion() async {
    try {
      if (await RemoteServices.addOpinion(
          _getStorage.read("token"), product.id, myRate.toString(), commentController.text)) {
        Get.defaultDialog(title: "success".tr, middleText: "opinion added".tr);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      //
    }
  }

  //todo: make a request to refresh this page alone
}
