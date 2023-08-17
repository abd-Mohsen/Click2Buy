import 'dart:convert';

List<VariantModel2> variantModel2FromJson(String str) =>
    List<VariantModel2>.from(json.decode(str).map((x) => VariantModel2.fromJson(x)));

String variantModel2ToJson(List<VariantModel2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariantModel2 {
  final int id;
  final String title;
  final String colour;
  final String material;
  final String size;
  final int quantity;
  final int price;
  final String photo;

  VariantModel2({
    required this.id,
    required this.title,
    required this.colour,
    required this.material,
    required this.size,
    required this.quantity,
    required this.price,
    required this.photo,
  });

  factory VariantModel2.fromJson(Map<String, dynamic> json) => VariantModel2(
        id: json["inventory_id"],
        title: json["title"],
        colour: json["colour"],
        material: json["material"],
        size: json["size"],
        quantity: json["quantity"],
        price: json["price"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "inventory_id": id,
        "title": title,
        "colour": colour,
        "material": material,
        "size": size,
        "quantity": quantity,
        "price": price,
        "photo": photo,
      };
}
