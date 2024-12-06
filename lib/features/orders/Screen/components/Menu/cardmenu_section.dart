import 'package:auto_size_text/auto_size_text.dart';  // Import AutoSizeText package
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import intl package
import 'package:kontena_pos/data/menu.dart';

class CardMenu extends StatelessWidget {
  final void Function(String name, int price, String idMenu, String type) onMenuTap;
  final String filterType;
  final String searchQuery;

  const CardMenu({
    Key? key,
    required this.onMenuTap,
    required this.filterType,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 800;

    int crossAxisCount = isWideScreen ? 4 : 2;

    final filteredMenu = ListMenu.where((menu) {
      final matchesType = filterType == 'All' || menu['type'].toString().toLowerCase() == filterType.toLowerCase();
      final matchesSearch = searchQuery.isEmpty || menu['nama_menu'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();

    // Create a NumberFormat instance for Indonesian locale
    final NumberFormat currencyFormat = NumberFormat('#,###', 'id_ID');

    return Container(
      width: screenWidth * 0.65,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: filteredMenu.length,
        itemBuilder: (context, index) {
          final menu = filteredMenu[index];
          final harga = int.tryParse(menu['harga'].toString()) ?? 0; // Convert price to integer

          return GestureDetector(
            onTap: () {
              onMenuTap(
                menu['nama_menu'].toString(),
                menu['harga'],
                menu['id_menu'].toString(),
                menu['type'].toString(),
              );
            },
            child: Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 2.03,
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(Icons.image, size: 50.0, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          menu['type'].toString(),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 1,
                          minFontSize: 10, // Minimum font size
                        ),
                        AutoSizeText(
                          menu['nama_menu'].toString(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          minFontSize: 12, // Minimum font size
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenWidth * 0.001),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: AutoSizeText(
                            'Rp ${currencyFormat.format(harga)}', // Format price with thousands separator
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            maxLines: 1,
                            minFontSize: 12, // Minimum font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
