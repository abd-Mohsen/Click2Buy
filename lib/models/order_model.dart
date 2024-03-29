import 'dart:convert';

import 'package:test1/models/variant_model2.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  final int id;
  final double totalPrice;
  final String status;
  final String userName;
  final DeliveryCompany deliveryCompany;
  final List<VariantModel2> variants;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.userName,
    required this.deliveryCompany,
    required this.variants,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["order_id"],
        totalPrice: json["total_price"]?.toDouble(),
        status: json["status"],
        userName: json["user_name"],
        deliveryCompany: DeliveryCompany.fromJson(json["delivary_company"]),
        variants: List<VariantModel2>.from(json["products"].map((x) => VariantModel2.fromJson(x))),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": id,
        "total_price": totalPrice,
        "status": status,
        "user_name": userName,
        "delivary_company": deliveryCompany.toJson(),
        "products": List<dynamic>.from(variants.map((x) => x.toJson())),
        "date": date.toIso8601String(),
      };
}

class DeliveryCompany {
  final int id;
  final String name;
  final String address;

  DeliveryCompany({
    required this.id,
    required this.name,
    required this.address,
  });

  factory DeliveryCompany.fromJson(Map<String, dynamic> json) => DeliveryCompany(
        id: json["id"],
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
      };
}
