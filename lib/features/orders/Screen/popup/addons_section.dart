import 'package:flutter/material.dart';
import 'package:kontena_pos/data/addons_preference.dart';

class AddonSection extends StatefulWidget {
  final String type;
  final Map<String, Map<String, dynamic>> selectedAddons; // Add Map to store addon prices
  final Function(Map<String, Map<String, dynamic>>) onAddonChanged;

  AddonSection({
    required this.type,
    required this.selectedAddons,
    required this.onAddonChanged,
  });

  @override
  _AddonSectionState createState() => _AddonSectionState();
}

class _AddonSectionState extends State<AddonSection> {
  late Map<String, Map<String, dynamic>> _selectedAddons;

  @override
  void initState() {
    super.initState();
    _selectedAddons = Map.from(widget.selectedAddons);
  }

  @override
  Widget build(BuildContext context) {
    // Use the addons data from addons_data.dart
    Map<String, double> addons = addonsByType[widget.type] ?? {};

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Addons:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: addons.entries.map((entry) {
                  final addon = entry.key;
                  final price = entry.value;
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addon,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Rp ${price.toStringAsFixed(0)}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        value: _selectedAddons[addon]?['selected'] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedAddons[addon] = {
                              'selected': value ?? false,
                              'price': price,
                               'name': addon, // Tambahkan name di sini
                            };
                            widget.onAddonChanged(_selectedAddons);
                          });
                        },
                        controlAffinity:
                            ListTileControlAffinity.trailing, // Align checkbox to the right
                      ),
                      SizedBox(height: 8.0), // Add spacing between Checkboxes
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
