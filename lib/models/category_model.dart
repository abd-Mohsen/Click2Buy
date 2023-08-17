import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<CategoryModel>.from(data.map((x) => x.toJson())));

class CategoryModel {
  final int id;
  final String name;
  final String photo;
  final dynamic parentId;
  final int childrenCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.parentId,
    required this.childrenCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        parentId: json["parent_id"],
        childrenCount: json["number_of_children"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "parent_id": parentId,
        "number_of_children": childrenCount,
      };
}
