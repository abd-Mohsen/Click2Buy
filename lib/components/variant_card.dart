import 'package:flutter/material.dart';
import 'package:test1/constants.dart';
import 'package:test1/models/variant_model1.dart';

class VariantCard extends StatelessWidget {
  final VariantModel1 variant;
  final bool isSelected;
  final void Function() onSelect;
  const VariantCard({super.key, required this.variant, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? cs.primary : cs.primary.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${variant.colour} | ${variant.size} | ${variant.material}",
              style: kTextStyle20.copyWith(color: cs.onPrimary)),
        ),
      ),
    );
  }
}
