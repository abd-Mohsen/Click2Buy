import 'dart:convert';

import 'package:test1/models/category_model.dart';
import 'package:test1/models/product_model.dart';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  final List<CategoryModel> subCategories;
  final List<ProductModel> products;

  SubCategoryModel({
    required this.subCategories,
    required this.products,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        subCategories: List<CategoryModel>.from(json["sub category"].map((x) => CategoryModel.fromJson(x))),
        products: List<ProductModel>.from(json["products"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sub category": List<CategoryModel>.from(subCategories.map((x) => x.toJson())),
        "products": List<ProductModel>.from(products.map((x) => x.toJson())),
      };
}
