import 'dart:convert';

import 'package:test1/models/product_model.dart';

List<WishlistModel> wishlistModelFromJson(String str) =>
    List<WishlistModel>.from(json.decode(str).map((x) => WishlistModel.fromJson(x)));

String wishlistModelToJson(List<WishlistModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistModel {
  final int wishListId;
  final List<ProductModel> product;

  WishlistModel({
    required this.wishListId,
    required this.product,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        wishListId: json["wish_list_id"],
        product: List<ProductModel>.from(json["product"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wish_list_id": wishListId,
        "product": List<dynamic>.from(product.map((x) => x.toJson())),
      };
}
