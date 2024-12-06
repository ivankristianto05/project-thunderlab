import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummarySection extends StatelessWidget {
  final String name;
  final int price;
  final String type;
  final String? selectedVariant;
  final int selectedPreferenceIndex;
  final Map<String, Map<String, dynamic>> selectedAddons; // Now using Map<String, dynamic>
  final String notes;
  final int quantity;
  final Function(int) onQuantityChanged;
  final int variantPrice;

  SummarySection({
    required this.name,
    required this.price,
    required this.type,
    required this.selectedVariant,
    required this.selectedPreferenceIndex,
    required this.selectedAddons,
    required this.notes,
    required this.quantity,
    required this.onQuantityChanged,
    required this.variantPrice,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,###', 'id_ID');

    final selectedAddonList = selectedAddons.entries
    .where((entry) => entry.value['selected'] == true)
    .map((entry) => entry.value['name']) // Mengakses key 'name'
    .join(', ') ?? '-';


    final selectedPreference = selectedPreferenceIndex >= 0
        ? type == 'food'
            ? [
                'original',
                'hot',
                'very hot',
                'no sauce',
                'no MSG',
                'no salt'
              ][selectedPreferenceIndex]
            : type == 'beverage'
                ? ['less sugar', 'less ice'][selectedPreferenceIndex]
                : ['small', 'medium', 'jumbo'][selectedPreferenceIndex]
        : '-';

    final int effectivePrice = (selectedVariant != null && selectedVariant!.isNotEmpty)
        ? variantPrice
        : price;

    final String displayedVariant = (selectedVariant != null && selectedVariant!.isNotEmpty)
        ? selectedVariant!
        : 'Original';

    return LayoutBuilder(
      builder: (context, constraints) {
        final double popupHeight = MediaQuery.of(context).size.height * 0.7;
        final double verticalSpacing = popupHeight * 0.01;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text('Summary:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: verticalSpacing),
                      Container(
                        child: Text(name, style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: verticalSpacing),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Variant:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(displayedVariant,
                                style: TextStyle(fontSize: 14)),
                            Text("Rp ${currencyFormat.format(effectivePrice)}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Addons:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(selectedAddonList,
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preference:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(selectedPreference,
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Notes:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(notes.isNotEmpty ? notes : '-',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: verticalSpacing),
                      Divider(),
                      SizedBox(height: verticalSpacing),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            onQuantityChanged(quantity > 1 ? quantity - 1 : 1);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('$quantity',
                              style: TextStyle(
                                  fontSize: 16)),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            onQuantityChanged(quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
