import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test1/models/product_model.dart';
import 'package:get/get.dart';
import 'package:test1/views/product_view.dart';
import '../constants.dart';

class WishlistCard extends StatelessWidget {
  final ProductModel product;
  final void Function() onDelete;
  const WishlistCard({super.key, required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    String heroTag = "${product.id}wishlist";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: ListTile(
          onTap: () {
            Get.to(ProductView(product: product, heroTag: heroTag));
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor: cs.surface,
          leading: Hero(
            tag: heroTag,
            child: SizedBox(
              height: 50,
              width: 50,
              child: CachedNetworkImage(
                imageUrl: "$kHostIP/storage/${product.photos[0].replaceFirst("public", "storage")}",
                height: 50,
                httpHeaders: const {'Connection': 'keep-alive'},
                placeholder: (context, url) => SpinKitFadingCircle(
                  color: cs.primary,
                  size: 5,
                  duration: const Duration(milliseconds: 1000),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            product.title,
            style: kTextStyle20.copyWith(color: cs.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.remove, color: cs.error),
          ),
        ),
      ),
    );
  }
}
