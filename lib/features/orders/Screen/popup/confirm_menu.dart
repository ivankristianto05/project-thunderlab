import 'package:flutter/material.dart';
import 'package:kontena_pos/data/menu.dart'; // Pastikan path ini benar

class ConfirmInputMenu extends StatefulWidget {
  final Function(Map<String, dynamic>) onMenuSelected; // Tambahkan callback

  ConfirmInputMenu({required this.onMenuSelected});

  @override
  _ConfirmInputMenuState createState() => _ConfirmInputMenuState();
}

class _ConfirmInputMenuState extends State<ConfirmInputMenu> {
  // Fungsi untuk melacak pemilihan menu dan meneruskannya ke parent widget
  void _onMenuSelected(Map<String, dynamic> selectedMenu) {
    widget.onMenuSelected(selectedMenu); // Panggil callback saat menu dipilih
  }

  // Widget untuk halaman Menu
  Widget _buildMenuPage() {
    final popupWidth = MediaQuery.of(context).size.width * 0.9; // Lebar pop-up
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Menu',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        // Tombol filter
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Wrap(
              spacing: popupWidth * 0.005, // Spacing antara tombol
              children: [
                _buildFilterButton('All', isSelected: true),
                _buildFilterButton('Food'),
                _buildFilterButton('Beverage'),
                _buildFilterButton('Breakfast'),
                _buildFilterButton('Other'),
              ],
            ),
          ),
        ),
        // Scrollable Menu Cards
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 cards per baris
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 3, // Aspect ratio card
            ),
            itemCount: ListMenu.length, // Mengambil jumlah item dari ListMenu
            itemBuilder: (context, index) {
              final menu = ListMenu[index]; // Akses data dari ListMenu
              return GestureDetector(
                onTap: () => _onMenuSelected(menu), // Pass selected menu on tap
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(menu['type'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13)),
                            SizedBox(height: 2),
                            Text(menu['nama_menu'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            'Rp ${menu['harga']}',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  // Tombol filter
  Widget _buildFilterButton(String label, {bool isSelected = false}) {
    return MaterialButton(
      onPressed: () {
        // Handle filter logic di sini
      },
      color: isSelected ? Colors.blue : Colors.black,
      textColor: Colors.white,
      height: 45, // Tinggi tombol
      minWidth: 80, // Lebar tombol
      child: Text(
        label,
        style: TextStyle(fontSize: 14), // Ukuran font tombol
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMenuPage(); // Kembalikan widget menu
  }
}
