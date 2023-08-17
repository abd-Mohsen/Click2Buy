import 'dart:convert';

import 'package:test1/models/product_model.dart';

List<ProductRowModel> productRowModelFromJson(String str) =>
    List<ProductRowModel>.from(json.decode(str).map((x) => ProductRowModel.fromJson(x)));

String productRowModelToJson(List<ProductRowModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductRowModel {
  final int id;
  final String rowName;
  final List<ProductModel> products;

  ProductRowModel({
    required this.id,
    required this.rowName,
    required this.products,
  });

  factory ProductRowModel.fromJson(Map<String, dynamic> json) => ProductRowModel(
        id: json["id"],
        rowName: json["row_name"],
        products: List<ProductModel>.from(json["product"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "row_name": rowName,
        "product": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
