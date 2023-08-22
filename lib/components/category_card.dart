import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/category_model.dart';
import 'package:test1/views/category_view.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final String heroTag;
  const CategoryCard({super.key, required this.category, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          //Get.create(() => CategoryController(categoryId: category.id));
          Get.to(() => CategoryView(category: category, heroTag: heroTag), preventDuplicates: false);
        },
        child: Hero(
          tag: heroTag,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: "$kHostIP/storage/${category.photo.replaceFirst("public", "storage")}",
                  httpHeaders: kImageHeaders,
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: cs.primary,
                    size: 40,
                    duration: const Duration(milliseconds: 1000),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                //top: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text.rich(
                    TextSpan(
                      text: "${category.name}\n",
                      style: kTextStyle26Bold.copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "${category.childrenCount} ${"sub-category".tr}",
                          style: kTextStyle20.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
