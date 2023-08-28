import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/models/filter_model.dart';
import 'package:test1/services/remote_services.dart';
import '../models/product_model.dart';

//todo: show "product is no longer available" if clicked on a deleted product in history and remove it from history
//todo: limit search history to latest 20 for example

//todo: dispose controller after closing search page
//todo: search products arent updating correctly

class MySearchController extends GetxController {
  final _getStorage = GetStorage(); //local storage

  @override
  void onInit() {
    super.onInit();
    getFilters();
    loadHistoryFromLocalStorage();
  }

  //todo: make sure that response is empty when failed
  late List<ProductModel> _searchResult = [];
  List<ProductModel> get searchResult => _searchResult;

  final Map<int, ProductModel> _searchHistory = {};
  Map<int, ProductModel> get searchHistory => _searchHistory; //Map = LinkedHashmap in dart

  String? color;
  String? brand;
  String? size;
  String? material;

  late FilterModel? _filters;
  FilterModel? get filters => _filters;

  double startPrice = 0.0;
  double endPrice = 999.9;

  double startRating = 0.0;
  double endRating = 5.0;

  bool isLoading = false;

  void clearFilters() {
    color = null;
    brand = null;
    size = null;
    material = null;
    startPrice = 0.0;
    endPrice = 999.9;
    startRating = 0.0;
    endRating = 5.0;
    update();
  }

  void setLoading(bool val) {
    isLoading = val;
    update();
  }

  void changePriceSlider(RangeValues rangeValues) {
    startPrice = rangeValues.start;
    endPrice = rangeValues.end;
    update();
  }

  void changeRateSlider(RangeValues rangeValues) {
    startRating = rangeValues.start;
    endRating = rangeValues.end;
    update();
  }

  Future<void> getFilters() async {
    try {
      _filters = (await RemoteServices.fetchFilters())!;
    } catch (e) {
      //
    } finally {
      //
    }
  }

  Future<void> searchRequest(String query) async {
    try {
      setLoading(true);
      _searchResult = (await RemoteServices.search(brand, color, material, size, query))!;
    } catch (e) {
      //
    } finally {
      setLoading(false);
    }
    print(query);
  }

  void addToHistory(ProductModel product) {
    if (_searchHistory.containsKey(product.id)) removeFromHistory(product);
    _searchHistory[product.id] = product;
    update();
    saveHistoryInLocalStorage();
  }

  void removeFromHistory(ProductModel product) {
    _searchHistory.remove(product.id);
    update();
    saveHistoryInLocalStorage();
  }

  void loadHistoryFromLocalStorage() {
    if (_getStorage.read("search history") != null) {
      List<ProductModel> mapAsList = productModelFromJson(_getStorage.read("search history"));
      for (ProductModel productModel in mapAsList) {
        _searchHistory[productModel.id] = productModel;
      }
    }
  }

  void saveHistoryInLocalStorage() {
    List<ProductModel> mapAsList = _searchHistory.entries.map((entry) => entry.value).toList();
    _getStorage.write("search history", productModelToJson(mapAsList));
  }
}
