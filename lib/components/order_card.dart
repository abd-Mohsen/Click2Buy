import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test1/models/order_model.dart';
import 'package:test1/views/edit_order_view.dart';
import '../constants.dart';
import 'order_subcard.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;
  //'waiting', 'processing', 'delivering', 'delivered'
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        backgroundColor: cs.surface,
        collapsedBackgroundColor: cs.surface,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "#${order.id}",
              style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.7)),
            ),
            if (order.status == "waiting" || order.status == "processing" || order.status == "delivering")
              const Icon(Icons.timelapse)
            else if (order.status == "delivered")
              const Icon(Icons.task_alt, color: Colors.green)
            else
              const Icon(Icons.dangerous_outlined, color: Colors.red)
          ],
        ),
        title: Text(
          "${DateFormat('yyyy-MM-dd').format(order.date)}\n${DateFormat('h:mm a').format(order.date)}",
          style: kTextStyle20.copyWith(color: cs.onSurface, fontWeight: FontWeight.w400),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "(${order.variants.length} ${"items".tr})",
            style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.6)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // trailing: CircleAvatar(
        //   radius: 20,
        //   backgroundColor: cs.primary,
        //   child: Icon(
        //     Icons.keyboard_arrow_down,
        //     color: cs.onPrimary,
        //     size: 25,
        //   ),
        // ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        children: [
          Divider(
            color: cs.onSurface,
            thickness: 1,
            indent: MediaQuery.of(context).size.width / 7,
            endIndent: MediaQuery.of(context).size.width / 7,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: order.variants.length,
              itemBuilder: (context, i) => OrderSubCard(variant: order.variants[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(EditOrderView(order: order));
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit".tr,
                      style: kTextStyle22.copyWith(color: cs.onPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.edit, color: cs.onPrimary),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "${"total".tr}: ${order.totalPrice}\$",
              style: kTextStyle16.copyWith(color: cs.onSurface.withOpacity(0.6)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
