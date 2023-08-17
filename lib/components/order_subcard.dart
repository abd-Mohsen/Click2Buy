import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../models/variant_model.dart';

class OrderSubCard extends StatelessWidget {
  final VariantModel variant;
  const OrderSubCard({super.key, required this.variant});

  //todo: add parent product name for variant
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        // leading: CachedNetworkImage(
        //   imageUrl: "$kHostIP/storage/${variant.photo!}",
        //   height: 50,
        //   httpHeaders: const {'Connection': 'keep-alive'},
        //   placeholder: (context, url) => SpinKitFadingCircle(
        //     color: cs.primary,
        //     size: 5,
        //     duration: const Duration(milliseconds: 1000),
        //   ),
        //   fit: BoxFit.cover,
        // ),
        title: Text(
          "variant",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Text(
          "x${variant.quantity ?? 0}",
          style: kTextStyle20.copyWith(color: cs.onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "${(variant.price ?? 0).toString()}\$",
                style: kTextStyle16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
