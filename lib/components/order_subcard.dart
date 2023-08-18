import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../models/variant_model2.dart';

class OrderSubCard extends StatelessWidget {
  final VariantModel2 variant;
  const OrderSubCard({super.key, required this.variant});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: variant.photo != "not found"
            ? SizedBox(
                height: 60,
                width: 60,
                child: CachedNetworkImage(
                  imageUrl: "$kHostIP/storage/${variant.photo}",
                  height: 50,
                  httpHeaders: const {'Connection': 'keep-alive'},
                  placeholder: (context, url) => SpinKitFadingCircle(
                    color: cs.primary,
                    size: 5,
                    duration: const Duration(milliseconds: 1000),
                  ),
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox.shrink(),
        title: Text(
          variant.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Text(
          "x${variant.quantity}",
          style: kTextStyle20.copyWith(color: cs.onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "${(variant.price).toString()}\$",
                style: kTextStyle16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
