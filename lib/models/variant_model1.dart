import 'dart:convert';

List<VariantModel1> variantModel1FromJson(String str) =>
    List<VariantModel1>.from(json.decode(str).map((x) => VariantModel1.fromJson(x)));

String variantModel1ToJson(List<VariantModel1> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariantModel1 {
  final int id;
  final String title;
  final String colour;
  final String material;
  final String size;
  final int price;
  final int quantity;
  final String image;

  VariantModel1({
    required this.id,
    required this.title,
    required this.colour,
    required this.material,
    required this.size,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory VariantModel1.fromJson(Map<String, dynamic> json) => VariantModel1(
        id: json["inventory_id"],
        title: json["title"],
        colour: json["colour"],
        material: json["material"],
        size: json["size"],
        price: json["price"],
        quantity: json["quantity"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "inventory_id": id,
        "title": title,
        "colour": colour,
        "material": material,
        "size": size,
        "price": price,
        "quantity": quantity,
        "image": image,
      };
}
