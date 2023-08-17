import 'package:flutter/material.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/variant_model.dart';

class EditOrderCard extends StatelessWidget {
  final VariantModel variant;
  final VoidCallback deleteCallback;
  final VoidCallback increaseCallback;
  final VoidCallback decreaseCallback;

  const EditOrderCard({
    super.key,
    required this.deleteCallback,
    required this.increaseCallback,
    required this.decreaseCallback,
    required this.variant,
  });
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
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
                  leading: variant.photo == "not found"
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.network(
                            "$kHostIP/storage/${variant.photo}",
                            headers: const {'Connection': 'keep-alive'},
                          ),
                        )
                      : const SizedBox.shrink(),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variant.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle20.copyWith(color: cs.onSurface),
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 20,
                    backgroundColor: cs.error,
                    child: IconButton(
                      onPressed: deleteCallback,
                      icon: Icon(
                        Icons.delete,
                        color: cs.onError,
                        size: 25,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("${variant.colour!} | ${variant.size!} | ${variant.material!}",
                          style: kTextStyle14, overflow: TextOverflow.ellipsis),
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
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: decreaseCallback,
                              icon: Icon(
                                Icons.remove,
                                color: variant.quantity == 1 ? cs.onSurface.withOpacity(0.3) : cs.primary,
                              ),
                            ),
                            Text(
                              variant.quantity.toString(),
                              style: kTextStyle26.copyWith(color: cs.onSurface),
                            ),
                            IconButton(
                              onPressed: increaseCallback,
                              icon: Icon(
                                Icons.add,
                                color: variant.quantity! >= variant.quantity!.toInt()
                                    ? cs.onSurface.withOpacity(0.3)
                                    : cs.primary,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${((variant.price!) * variant.quantity!)}\$",
                        //"0000000",
                        style: kTextStyle24Bold.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
