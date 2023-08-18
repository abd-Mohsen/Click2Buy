import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/models/product_model.dart';

class FullViewController extends GetxController {
  double _priceSliderStartValue = 0.0;
  double get priceSliderStartValue => _priceSliderStartValue;

  double _priceSliderEndValue = 1000;
  double get priceSliderEndValue => _priceSliderEndValue;

  void changePriceSliderValue(RangeValues rangeValues) {
    _priceSliderStartValue = rangeValues.start.toPrecision(1);
    _priceSliderEndValue = rangeValues.end.toPrecision(1);
    update();
  }

  double _rateSliderStartValue = 0;
  double get rateSliderStartValue => _rateSliderStartValue;

  double _rateSliderEndValue = 5;
  double get rateSliderEndValue => _rateSliderEndValue;

  void changeRateSliderValue(RangeValues rangeValues) {
    _rateSliderStartValue = rangeValues.start;
    _rateSliderEndValue = rangeValues.end;
    update();
  }

  late String _selectedBrand;
  String get selectedBrand => _selectedBrand;

  List<ProductModel> filteredList(List<ProductModel> list) {
    // List<ProductModel> filteredList = [];
    // for (ProductModel product in list) {
    //   if (product.price >= _priceSliderStartValue &&
    //       product.price <= _priceSliderEndValue &&
    //       product.rating![0].value! >= _rateSliderStartValue &&
    //       product.rating![0].value! <= _rateSliderEndValue) {
    //     filteredList.add(product);
    //   }
    // }
    //return filteredList;
    return list
        .where((p) =>
            p.price >= _priceSliderStartValue &&
            p.price <= _priceSliderEndValue &&
            (p.rating.isNotEmpty ? p.rating[0].value : 0) >= _rateSliderStartValue &&
            (p.rating.isNotEmpty ? p.rating[0].value : 0) <= _rateSliderEndValue)
        .toList();
  }
}
