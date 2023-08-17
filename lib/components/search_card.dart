import 'package:flutter/material.dart';
import 'package:test1/constants.dart';
import '../models/product_model.dart';

class SearchCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onPress;
  const SearchCard({super.key, required this.product, required this.onPress});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            //tileColor: cs.surface,
            leading: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Image.network(
                "$kHostIP/storage/${product.photos![0]}",
                headers: const {'Connection': 'keep-alive'},
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: cs.onBackground,
                      ),
                    );
                  }
                },
              ),
            ),
            title: Text(
              product.title,
              style: kTextStyle16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: onPress,
          ),
          Divider(color: cs.onSurface)
        ],
      ),
    );
  }
}
