import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kontena_pos/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.screenWidth,
    required this.onOrderSelected,
    required this.orderan, // Pass orders as parameter
    required this.currentOrderId, // Pass the currently selected order ID as parameter
  });

  final double screenWidth;
  final void Function(String orderId) onOrderSelected;
  final List<dynamic>
      orderan; // Assume OrderModel is your data structure for orders
  final String currentOrderId; // The currently selected order ID

  @override
  Widget build(BuildContext context) {
    if (orderan.isEmpty) {
      return const Center(
        child: AutoSizeText('No order available.'),
      );
    }

    final cardWidth = (screenWidth * 0.65) / 3 - 20;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(orderan.length, (index) {
            final order = orderan[index];
            final isSelected = order.idOrder == currentOrderId;

            return GestureDetector(
              onTap: () {
                onOrderSelected(order.idOrder);
              },
              child: SizedBox(
                width: cardWidth,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          isSelected ? buttonselectedcolor : Colors.transparent,
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              'Table ${order.table}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              minFontSize: 10,
                              maxFontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AutoSizeText(
                              DateFormat('dd-MM-yyyy HH:mm').format(
                                  order.time), // Convert DateTime to String
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              minFontSize: 10,
                              maxFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AutoSizeText(
                          order.namaPemesan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 16,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: order.items.length,
                              itemBuilder: (context, i) {
                                final cartItem = order.items[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cartItem.qty}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              "${cartItem.name} - ${cartItem.variant ?? ''}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              minFontSize: 10,
                                              maxFontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (cartItem.preference !=
                                                null) ...[
                                              const SizedBox(height: 4),
                                              AutoSizeText(
                                                "Preference: ${cartItem.preference.values.join(', ')}",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            if (cartItem.addons != null &&
                                                cartItem
                                                    .addons!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              AutoSizeText(
                                                "+ ${cartItem.addons!.keys.join(', ')}",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            if (cartItem.notes != null) ...[
                                              const SizedBox(height: 4),
                                              AutoSizeText(
                                                "Notes: ${cartItem.notes}",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      AutoSizeText(
                                        order.status,
                                        style: TextStyle(
                                          color: order.status == 'Confirmed'
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 10,
                                        maxFontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
