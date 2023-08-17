import 'dart:convert';

FilterModel filterModelFromJson(String str) => FilterModel.fromJson(json.decode(str));

String filterModelToJson(FilterModel data) => json.encode(data.toJson());

class FilterModel {
  //final List<Category> category;
  final List<Brand> colour;
  final List<Brand> material;
  final List<Size> size;
  final List<Brand> brand;

  FilterModel({
    //required this.category,
    required this.colour,
    required this.material,
    required this.size,
    required this.brand,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        //category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
        colour: List<Brand>.from(json["colour"].map((x) => Brand.fromJson(x))),
        material: List<Brand>.from(json["material"].map((x) => Brand.fromJson(x))),
        size: List<Size>.from(json["size"].map((x) => Size.fromJson(x))),
        brand: List<Brand>.from(json["brand"].map((x) => Brand.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        //"category": List<dynamic>.from(category.map((x) => x.toJson())),
        "colour": List<dynamic>.from(colour.map((x) => x.toJson())),
        "material": List<dynamic>.from(material.map((x) => x.toJson())),
        "size": List<dynamic>.from(size.map((x) => x.toJson())),
        "brand": List<dynamic>.from(brand.map((x) => x.toJson())),
      };
}

class Brand {
  final String name;

  Brand({
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Size {
  final String size;

  Size({
    required this.size,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
      };
}
