import 'dart:convert';

import 'package:test1/models/variant_model.dart';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  final int orderId;
  final int totalPrice;
  final String status;
  final String userName;
  final DeliveryCompany deliveryCompany;
  final List<VariantModel> variants;

  OrderModel({
    required this.orderId,
    required this.totalPrice,
    required this.status,
    required this.userName,
    required this.deliveryCompany,
    required this.variants,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["order_id"],
        totalPrice: json["total_price"],
        status: json["status"],
        userName: json["user_name"],
        deliveryCompany: DeliveryCompany.fromJson(json["delivary_company"]),
        variants: List<VariantModel>.from(json["products"].map((x) => VariantModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_price": totalPrice,
        "status": status,
        "user_name": userName,
        "delivary_company": deliveryCompany.toJson(),
        "products": List<dynamic>.from(variants.map((x) => x.toJson())),
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
