import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) =>
    List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  final int id;
  final List<String> address;

  AddressModel({
    required this.id,
    required this.address,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        address: List<String>.from(json["address"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": List<dynamic>.from(address.map((x) => x)),
      };
}
