import 'dart:convert';

import 'package:test1/models/comment_model.dart';
import 'package:test1/models/variant_model1.dart';

List<ProductModel> productModelFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final int id;
  final String title;
  final String description;
  final int price;
  final Brand brand;
  final Offer offer;
  final Brand category;
  final List<VariantModel1> variants;
  final List<CommentModel> comments;
  final List<Rating> rating;
  final List<String> photos;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.offer,
    required this.category,
    required this.variants,
    required this.comments,
    required this.rating,
    required this.photos,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        description: json["descraption"],
        price: json["price"],
        brand: Brand.fromJson(json["brand"]),
        offer: Offer.fromJson(json["offer"]),
        category: Brand.fromJson(json["category"]),
        variants: List<VariantModel1>.from(json["details"].map((x) => VariantModel1.fromJson(x))),
        comments: List<CommentModel>.from(json["ratings_and_comments"].map((x) => CommentModel.fromJson(x))),
        rating: List<Rating>.from(json["evaluation"].map((x) => Rating.fromJson(x))),
        photos: List<String>.from(json["photos"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "descraption": description,
        "price": price,
        "brand": brand.toJson(),
        "offer": offer.toJson(),
        "category": category.toJson(),
        "details": List<dynamic>.from(variants.map((x) => x.toJson())),
        "ratings_and_comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "evaluation": List<dynamic>.from(rating.map((x) => x.toJson())),
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
      };
}

class Brand {
  final int id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Rating {
  final int value;
  final int count;

  Rating({
    required this.value,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        value: json["evaluation"],
        count: json["count_people_evaluation"],
      );

  Map<String, dynamic> toJson() => {
        "evaluation": value,
        "count_people_evaluation": count,
      };
}

class Offer {
  final int? value;

  Offer({
    required this.value,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
