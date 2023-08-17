import 'dart:convert';

List<CompanyModel> companyModelFromJson(String str) =>
    List<CompanyModel>.from(json.decode(str).map((x) => CompanyModel.fromJson(x)));

String companyModelToJson(List<CompanyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyModel {
  final int id;
  final String name;

  CompanyModel({
    required this.id,
    required this.name,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
