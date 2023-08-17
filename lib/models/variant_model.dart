import 'dart:convert';

List<VariantModel> variantModelFromJson(String str) =>
    List<VariantModel>.from(json.decode(str).map((x) => VariantModel.fromJson(x)));

String variantModelToJson(List<VariantModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariantModel {
  final int id;
  final String? colour;
  final String? title;
  final String? material;
  final String? size;
  final String? image;
  final String? photo;
  final int? quantity;
  final int? price;

  VariantModel({
    required this.title,
    required this.photo,
    required this.id,
    required this.colour,
    required this.material,
    required this.size,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
        id: json["inventory_id"],
        title: json["title"],
        colour: json["colour"],
        material: json["material"],
        size: json["size"],
        photo: json["photo"],
        image: json["image"],
        quantity: json["quantity"],
        price: json["price"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "inventory_id": id,
        "colour": colour,
        "material": material,
        "size": size,
        "image": image,
        "quantity": quantity,
        "price": price,
      };
}
