import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) =>
    List<CommentModel>.from(json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  final int commentId;
  final String userName;
  final String text;
  final int ratingId;
  final String? rating;

  CommentModel({
    required this.commentId,
    required this.userName,
    required this.text,
    required this.ratingId,
    required this.rating,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        commentId: json["comment_id"],
        userName: json["user_name"],
        text: json["text"],
        ratingId: json["rating_id"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "user_name": userName,
        "text": text,
        "rating_id": ratingId,
        "rating": rating,
      };
}
