import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/constants.dart';
import 'package:kontena_pos/data/menuvarian.dart';
import 'package:intl/intl.dart';

class VariantSection extends StatefulWidget {
  final String idMenu;
  final int selectedIndex;
  final Function(int, String, int) onVariantSelected;

  VariantSection({
    required this.idMenu,
    required this.selectedIndex,
    required this.onVariantSelected,
  });

  @override
  _VariantSectionState createState() => _VariantSectionState();
}

class _VariantSectionState extends State<VariantSection> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize with the prop
  }

  @override
  void didUpdateWidget(VariantSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _selectedIndex if selectedIndex prop changes
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _selectedIndex = widget.selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter MenuVarian based on idMenu
    final variants = MenuVarian.where((variant) => variant['id_menu'] == widget.idMenu).toList();


    final numberFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Variant:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(variants.length, (index) {
                  final variant = variants[index];
                  final isSelected = _selectedIndex == index;
                  final formattedPrice = numberFormat.format(variant['harga_varian']);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedIndex == index) {
                            _selectedIndex = -1;
                            widget.onVariantSelected(-1, '', 0);
                          } else {
                            _selectedIndex = index;
                            widget.onVariantSelected(index, variant['nama_varian'], variant['harga_varian']);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? buttonselectedcolor : Colors.white,
                          border: Border.all(
                              color: isSelected ? buttonselectedcolor : Colors.grey),
                        ),
                        child: ListTile(
                          title: AutoSizeText(
                            variant['nama_varian'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: AutoSizeText(
                            formattedPrice,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
