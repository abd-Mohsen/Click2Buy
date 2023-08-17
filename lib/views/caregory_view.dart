import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test1/components/category_card.dart';
import 'package:test1/components/product_card.dart';
import 'package:test1/controllers/category_controller.dart';
import 'package:test1/models/category_model.dart';

import '../constants.dart';

class CategoryView extends GetView<CategoryController> {
  final CategoryModel category;
  final String heroTag;

  const CategoryView({super.key, required this.category, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    //SubCategoryController sCC = Get.put(SubCategoryController(categoryId: category.id));
    //SubCategoryController sCC = Get.find();
    // Update the view whenever the controller changes
    //ever(sCC.categoryId, (_) => Get.forceAppUpdate());

    return Scaffold(
      backgroundColor: cs.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onBackground),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: cs.error,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                ClipRect(
                  child: SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: heroTag,
                      child: CachedNetworkImage(
                        imageUrl: "$kHostIP/${category.photo.replaceFirst("public", "storage")}",
                        fit: BoxFit.cover,
                        httpHeaders: kImageHeaders,
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: cs.primary,
                          size: 30,
                          duration: const Duration(milliseconds: 1000),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: cs.background.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category.name,
                      style: kTextStyle20.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<CategoryController>(
            //init: SubCategoryController(categoryId: category.id),
            builder: (con) => SliverFillRemaining(
              child: RefreshIndicator(
                onRefresh: con.refreshCategory,
                child: Column(
                  children: [
                    Expanded(
                      flex: 60,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250,
                        ),
                        itemCount: con.products.length,
                        itemBuilder: (context, i) => ProductCard(
                          con.products[i],
                          "${category.id}cat${con.products[i].id}pro",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 40,
                      child: ListView.builder(
                        itemCount: con.subCategories.length,
                        itemBuilder: (context, i) => CategoryCard(
                          category: con.subCategories[i],
                          heroTag: "cat${con.subCategories[i]}",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
