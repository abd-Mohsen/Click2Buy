import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../views/product_view.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String productCardHeroTag; //unique hero tag for every card

  const ProductCard(this.product, this.productCardHeroTag, {super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductView(product: product, heroTag: "product${product.id}$productCardHeroTag"));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 225,
            width: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Hero(
                          tag: "product${product.id}$productCardHeroTag",
                          child: Container(
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: "$kHostIP/storage/${product.photos[0].replaceFirst("public", "storage")}",
                              height: 50,
                              httpHeaders: const {'Connection': 'keep-alive'},
                              placeholder: (context, url) => SpinKitFadingCircle(
                                color: cs.primary,
                                size: 30,
                                duration: const Duration(milliseconds: 1000),
                              ),
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.fiber_new_sharp,
                          color: cs.error,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          style: kTextStyle14.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // RatingBar.builder(
                        //   ignoreGestures: true,
                        //   initialRating: product.rating[0].value.toDouble(),
                        //   glow: false,
                        //   itemSize: 12,
                        //   minRating: 1,
                        //   direction: Axis.horizontal,
                        //   allowHalfRating: true,
                        //   itemCount: 5,
                        //   itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                        //   itemBuilder: (context, _) => const Icon(
                        //     Icons.star,
                        //     color: Colors.amber,
                        //   ),
                        //   onRatingUpdate: (rating) {},
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            product.offer.value == null || product.offer.value == 0
                                ? Text(
                                    '\$${product.price.toDouble().toPrecision(2)}',
                                    style: kTextStyle18Bold.copyWith(color: cs.onSurface),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$${(product.price - (product.price * (product.offer.value! / 100))).toPrecision(2).toString()}',
                                        style: kTextStyle18Bold.copyWith(color: cs.onSurface),
                                      ),
                                      Text(
                                        '\$${product.price.toDouble().toPrecision(2)}',
                                        style: kTextStyle14.copyWith(
                                          color: cs.error.withOpacity(0.8),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                            GetBuilder<CartController>(
                              init: CartController(),
                              builder: (con) => GestureDetector(
                                onTap: () {
                                  con.addToCart(product.variants[0], product); //details is null
                                  Get.showSnackbar(GetSnackBar(
                                    messageText: Text(
                                      "added to cart".tr,
                                      textAlign: TextAlign.center,
                                      style: kTextStyle14.copyWith(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.grey.shade800,
                                    duration: const Duration(milliseconds: 800),
                                    borderRadius: 30,
                                    maxWidth: 200,
                                    margin: const EdgeInsets.only(bottom: 50),
                                  ));
                                },
                                child: CircleAvatar(
                                  backgroundColor: cs.primary,
                                  radius: 15,
                                  child: Icon(Icons.add_shopping_cart, size: 18, color: cs.onPrimary),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Fluttertoast.showToast(
//   //todo: no localization!?
//   msg: "added to cart".tr,
//   toastLength: Toast.LENGTH_SHORT,
//   gravity: ToastGravity.BOTTOM,
//   timeInSecForIosWeb: 1,
//   backgroundColor: Colors.grey.shade800,
//   textColor: Colors.white,
//   fontSize: 12,
// );
