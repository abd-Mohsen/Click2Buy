// import 'dart:async';
//
// import 'package:get/get.dart';
// import 'package:test1/models/product_model.dart';
// import 'package:test1/models/sub_cat_model.dart';
// import 'package:test1/services/remote_services.dart';
// import '../models/category_model.dart';
//
// // TODO: implement pagination
// class CategoryController extends GetxController {
//   final int categoryId;
//   int page = 1;
//   CategoryController({required this.categoryId});
//   @override
//   void onInit() {
//     super.onInit();
//     getCategory(categoryId);
//   }
//
//   late List<CategoryModel> _subCategories = [];
//   List<CategoryModel> get subCategories => _subCategories;
//
//   late List<ProductModel> _products = [];
//   List<ProductModel> get products => _products;
//
//   bool _isLoadingSubCategory = true;
//   bool get isLoadingSubCategory => _isLoadingSubCategory;
//
//   void setLoadingSubCategory(bool val) {
//     _isLoadingSubCategory = val;
//     update();
//   }
//
//   bool _isFetchedSubCat = false;
//   bool get isFetchedSubCat => _isFetchedSubCat;
//
//   void setFetchedSubCategory(bool val) {
//     _isFetchedSubCat = val;
//     update();
//   }
//
//   Future<void> getCategory(int id) async {
//     try {
//       //page++;
//       SubCategoryModel model = (await RemoteServices.fetchSubCategories(id, page))!;
//       _products = model.products;
//       _subCategories = model.subCategories;
//       setFetchedSubCategory(true);
//     } on TimeoutException {
//       setLoadingSubCategory(false);
//       // check ur internet fag
//     } catch (e) {
//       //
//     } finally {
//       setLoadingSubCategory(false);
//       //page = 1;
//     }
//   }
//
//   Future<void> refreshCategory() async {
//     setFetchedSubCategory(false);
//     setLoadingSubCategory(true);
//     page = 1;
//     getCategory(categoryId);
//   }
// }
