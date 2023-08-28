import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:test1/components/custom/abd_icons_icons.dart';
import 'package:test1/components/comment_card.dart';
import 'package:test1/components/variant_card.dart';
import 'package:test1/controllers/product_controller.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:test1/controllers/cart_controller.dart';
import '../constants.dart';
import '../models/product_model.dart';

//todo refresh this page alone and add it to cart
//todo controller is taking long to initialize after deletion
class ProductView extends StatelessWidget {
  final ProductModel product;
  final String heroTag;

  const ProductView({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    ProductController pC = Get.find();
    CartController cC = Get.find();
    bool isLoggedIn = GetStorage().hasData("token");
    return WillPopScope(
      onWillPop: () async {
        Get.delete<ProductController>();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: GetBuilder<ProductController>(builder: (con) {
            return SpeedDial(
              //controller: AnimationController(vsync: this), //fix if possible
              labelsBackgroundColor: cs.onSurface,
              labelsStyle: kTextStyle14Bold.copyWith(color: cs.surface),
              speedDialChildren: [
                SpeedDialChild(
                  child: const Icon(Icons.favorite),
                  foregroundColor: isLoggedIn ? cs.surface : Colors.grey[700],
                  backgroundColor: isLoggedIn ? Colors.redAccent : Colors.grey,
                  label: "add to wishlist".tr,
                  onPressed: () {
                    isLoggedIn
                        ? pC.addToWishlist()
                        : Get.showSnackbar(GetSnackBar(
                            messageText: Text(
                              "log in first".tr,
                              textAlign: TextAlign.center,
                              style: kTextStyle14.copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey.shade800,
                            duration: const Duration(milliseconds: 800),
                            borderRadius: 30,
                            maxWidth: 150,
                            margin: const EdgeInsets.only(bottom: 50),
                          ));
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.star),
                  foregroundColor: isLoggedIn ? cs.surface : Colors.grey[700],
                  backgroundColor: isLoggedIn ? Colors.amberAccent : Colors.grey,
                  label: "rate the product".tr,
                  onPressed: () {
                    TextEditingController comment = con.commentController;
                    isLoggedIn
                        ? Get.dialog(AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                children: [
                                  RatingBar.builder(
                                    initialRating: 0, //show the user previous rating
                                    glow: false,
                                    itemSize: 25,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      con.myRate = rating.toInt();
                                    },
                                  ),
                                  SingleChildScrollView(
                                    child: TextField(
                                      controller: comment,
                                      maxLines: 4,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: "describe your experience (optional)".tr,
                                        label: Text("comment".tr),
                                      ),
                                      onChanged: (String? s) {
                                        //
                                      },
                                      obscureText: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text("rate the product".tr),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  con.giveOpinion();
                                },
                                child: Text(
                                  "submit".tr,
                                  style: kTextStyle18.copyWith(color: cs.primary),
                                ),
                              ),
                            ],
                          ))
                        : Get.showSnackbar(GetSnackBar(
                            messageText: Text(
                              "log in first".tr,
                              textAlign: TextAlign.center,
                              style: kTextStyle14.copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey.shade800,
                            duration: const Duration(milliseconds: 800),
                            borderRadius: 30,
                            maxWidth: 150,
                            margin: const EdgeInsets.only(bottom: 50),
                          ));
                  },
                ),
                SpeedDialChild(
                  //closeSpeedDialOnPressed: true,
                  child: const Icon(Icons.add_shopping_cart),
                  foregroundColor: !pC.isSelected ? Colors.grey[700] : cs.surface,
                  backgroundColor: !pC.isSelected ? Colors.grey : Colors.blueAccent,
                  label: "add to cart".tr,
                  onPressed: () {
                    if (pC.isSelected) {
                      cC.addToCart(con.selectedVariant!, product);
                      Get.showSnackbar(GetSnackBar(
                        messageText: Text(
                          "added to cart".tr,
                          textAlign: TextAlign.center,
                          style: kTextStyle14.copyWith(color: Colors.white),
                        ),
                        backgroundColor: Colors.grey.shade800,
                        duration: const Duration(milliseconds: 800),
                        borderRadius: 30,
                        maxWidth: 150,
                        margin: const EdgeInsets.only(bottom: 50),
                      ));
                    } else {
                      Get.showSnackbar(GetSnackBar(
                        messageText: Text(
                          "select a variant first".tr,
                          textAlign: TextAlign.center,
                          style: kTextStyle14.copyWith(color: Colors.white),
                        ),
                        backgroundColor: Colors.grey.shade800,
                        duration: const Duration(milliseconds: 800),
                        borderRadius: 30,
                        maxWidth: 150,
                        margin: const EdgeInsets.only(bottom: 50),
                      ));
                    }
                  },
                ),
              ],
              closedForegroundColor: cs.onPrimary,
              openForegroundColor: cs.primary,
              closedBackgroundColor: cs.primary,
              openBackgroundColor: Get.isDarkMode ? cs.onPrimary : Colors.grey.shade200,
              child: const Icon(Icons.add),
            );
          }),
          backgroundColor: cs.background,
          appBar: AppBar(
            backgroundColor: cs.surface,
            centerTitle: true,
            title: Text(
              "product details".tr,
              style: kTextStyle26.copyWith(color: cs.onSurface),
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: cs.onSurface),
                onPressed: () {
                  Get.delete<ProductController>();
                  Get.back();
                }),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Hero(
                        tag: heroTag,
                        child: GetBuilder<ProductController>(
                          //dispose: (_) => pC.dispose(),
                          builder: (con) => CachedNetworkImage(
                            imageUrl: "$kHostIP/storage/${con.currentPicUrl}",
                            fit: BoxFit.fill,
                            httpHeaders: const {'Connection': 'keep-alive'},
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 2,
                                child: SpinKitPouringHourGlass(
                                  color: cs.onBackground,
                                  size: 100,
                                  duration: const Duration(milliseconds: 1000),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: cs.surface,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: kTextStyle30Bold.copyWith(color: cs.onSurface),
                      ),
                      Divider(
                        height: 30,
                        thickness: 3,
                        color: cs.primary,
                      ),
                      //todo: put info icon in the appbar
                      product.variants.isEmpty
                          ? const SizedBox.shrink()
                          : GetBuilder<ProductController>(
                              builder: (con) => SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: product.variants.length,
                                  // get builder
                                  itemBuilder: (context, i) => VariantCard(
                                    variant: product.variants[i],
                                    isSelected: con.selected[i],
                                    onSelect: () {
                                      con.changeVariant(product.variants[i], i);
                                    },
                                  ),
                                ),
                              ),
                            ),
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              "rating".tr,
                              style: kTextStyle30.copyWith(color: cs.onSurface),
                            ),
                            const SizedBox(width: 30),
                            Icon(
                              Icons.fiber_new_outlined,
                              color: cs.error,
                              size: 50,
                            ),
                          ],
                        ),
                        leading: Icon(Icons.star),
                        subtitle: Row(
                          children: [
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: product.rating.isEmpty ? 0.0 : product.rating[0].value.toDouble(),
                              glow: false,
                              itemSize: 20,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                //
                              },
                            ),
                            Text(
                              "(${product.rating.isNotEmpty ? product.rating[0].count : 0})",
                              style: kTextStyle20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ExpansionTile(
                        leading: const Icon(
                          AbdIcons.tag,
                          size: 30,
                          //color: cs.primary,
                        ),
                        title: Text(
                          "details".tr,
                          style: kTextStyle30.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "click for details".tr,
                            style: kTextStyle16,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              parse(product.description).documentElement!.text,
                              style: kTextStyle18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ExpansionTile(
                        leading: const Icon(
                          AbdIcons.forum,
                          size: 30,
                          //color: cs.primary,
                        ),
                        title: Text(
                          "comments".tr,
                          style: kTextStyle30.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "${product.comments.where((comment) => comment.text != "").length} ${"comments".tr}",
                            style: kTextStyle18,
                          ),
                        ),
                        children: [
                          SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView.builder(
                                  itemCount: product.comments.where((comment) => comment.text != "").length,
                                  itemBuilder: (context, i) => CommentCard(
                                    comment: product.comments.where((comment) => comment.text != "").toList()[i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      product.offer.value == null || product.offer.value == 0
                          ? Text(
                              '\$${product.price}',
                              style: kTextStyle50.copyWith(color: cs.onSurface, decoration: TextDecoration.underline),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${(product.price - (product.price * (product.offer.value! / 100))).toPrecision(2).toString()}',
                                  style:
                                      kTextStyle50.copyWith(color: cs.onSurface, decoration: TextDecoration.underline),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '\$${product.price}',
                                  style: kTextStyle30.copyWith(
                                    color: cs.error.withOpacity(0.6),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//todo: if !product -> pop this page

//todo: below the page put hashtags representing the category (and its parents if possible)
