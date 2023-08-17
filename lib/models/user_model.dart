import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final String name;
  final String email;
  final dynamic phone;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        phone: json["phone_number"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone_number": phone,
      };
}
