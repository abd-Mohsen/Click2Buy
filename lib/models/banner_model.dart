import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) =>
    List<BannerModel>.from(json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModel {
  final String photo;

  BannerModel({
    required this.photo,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "photo": photo,
      };
}
