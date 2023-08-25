import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/components/category_card.dart';
import 'package:test1/components/product_card.dart';
import 'package:test1/models/category_model.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../models/sub_cat_model.dart';
import '../services/remote_services.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel category;
  final String heroTag;

  const CategoryView({super.key, required this.category, required this.heroTag});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _page = 1;

  @override
  void initState() {
    super.initState();
    getCategory(widget.category.id);
  }

  late List<CategoryModel> _subCategories = [];
  List<CategoryModel> get subCategories => _subCategories;

  late List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoadingSubCategory = true;
  bool get isLoadingSubCategory => _isLoadingSubCategory;

  void setLoadingSubCategory(bool val) {
    setState(() {
      _isLoadingSubCategory = val;
    });
  }

  bool _isFetchedSubCat = false;
  bool get isFetchedSubCat => _isFetchedSubCat;

  void setFetchedSubCategory(bool val) {
    setState(() {
      _isFetchedSubCat = val;
    });
  }

  Future<void> getCategory(int id) async {
    try {
      SubCategoryModel model = (await RemoteServices.fetchSubCategories(id, _page))!;
      _products = model.products;
      if (model.subCategories.isNotEmpty) {
        _subCategories = model.subCategories;
      }
      setFetchedSubCategory(true);
    } on TimeoutException {
      setLoadingSubCategory(false);
      // check your internet connection
    } catch (e) {
      // handle the error
    } finally {
      setLoadingSubCategory(false);
    }
  }

  Future<void> refreshCategory() async {
    setFetchedSubCategory(false);
    setLoadingSubCategory(true);
    _page = 1;
    getCategory(widget.category.id);
  }

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
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Stack(
                children: [
                  ClipRect(
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: widget.heroTag,
                        child: CachedNetworkImage(
                          imageUrl: "$kHostIP/storage/${widget.category.photo}",
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
                        widget.category.name,
                        style: kTextStyle30Bold.copyWith(
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
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
          ),

          //init: SubCategoryController(categoryId: category.id),
          SliverFillRemaining(
            child: RefreshIndicator(
              onRefresh: refreshCategory,
              child: Column(
                children: [
                  Expanded(
                    flex: 60,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, i) => ProductCard(
                        products[i],
                        "${widget.category.parentId}${widget.category.id}cat${products[i].id}pro",
                      ),
                    ),
                  ),
                  const Divider(thickness: 2),
                  widget.category.childrenCount != 0
                      ? Expanded(
                          flex: 40,
                          child: ListView.builder(
                            itemCount: subCategories.length,
                            itemBuilder: (context, i) => CategoryCard(
                              category: subCategories[i],
                              heroTag: "cat${subCategories[i].id}${subCategories[i].parentId}",
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
