import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/constants.dart';
import 'package:test1/controllers/cart_controller.dart';
import 'package:test1/models/variant_model1.dart';
import 'package:test1/views/product_view.dart';

import '../models/product_model.dart';

class CartCard extends StatelessWidget {
  final ProductModel product;
  final VariantModel1 variant;
  final VoidCallback deleteCallback;
  final VoidCallback increaseCallback;
  final VoidCallback decreaseCallback;

  const CartCard({
    super.key,
    required this.product,
    required this.deleteCallback,
    required this.increaseCallback,
    required this.decreaseCallback,
    required this.variant,
  });
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    CartController cC = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                  tileColor: cs.surface,
                  leading: GestureDetector(
                    onTap: () {
                      Get.to(() => ProductView(product: product, heroTag: "cart${product.id}${variant.id}"));
                      //todo: if product is no longer available show a dialog
                    },
                    child: Hero(
                      tag: "cart${product.id}${variant.id}",
                      child: Image.network(
                        variant.image == "not found"
                            ? "$kHostIP/storage/${product.photos[0]}"
                            : "$kHostIP/storage/${variant.image}",
                        headers: const {'Connection': 'keep-alive'},
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle20.copyWith(color: cs.onSurface),
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 20,
                    backgroundColor: cs.primary,
                    child: IconButton(
                      onPressed: deleteCallback,
                      icon: Icon(
                        Icons.delete,
                        color: cs.onPrimary,
                        size: 25,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(variant.colour, style: kTextStyle16, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(variant.size, style: kTextStyle16, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(variant.material, style: kTextStyle16, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  )),
              Container(
                decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius:
                        const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        child: variant.quantity > 0
                            ? Row(
                                children: [
                                  IconButton(
                                    onPressed: decreaseCallback,
                                    icon: Icon(
                                      Icons.remove,
                                      color: cC.quantity[variant.id]! == 1 ? cs.onSurface.withOpacity(0.3) : cs.primary,
                                    ),
                                  ),
                                  Text(
                                    cC.quantity[variant.id]!.toString(),
                                    style: kTextStyle26.copyWith(color: cs.onSurface),
                                  ),
                                  IconButton(
                                    //todo: only increase if variantCount < variant quantity
                                    //todo: if users open a product that doesn't exist, delete that product/variant
                                    //todo: if variantCount > variant quantity, decrease count and show dialog about it
                                    onPressed: increaseCallback,
                                    icon: Icon(
                                      Icons.add,
                                      color: cC.quantity[variant.id]! >= variant.quantity.toInt()
                                          ? cs.onSurface.withOpacity(0.3)
                                          : cs.primary,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("out of stock".tr, style: kTextStyle20.copyWith(color: cs.error)),
                              )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${((variant.price - (variant.price * (product.offer.value ?? 0) / 100)) * cC.quantity[variant.id]!).toDouble()}\$",
                        style: kTextStyle24Bold.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
