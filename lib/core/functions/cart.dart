// import 'dart:ui';
// import 'package:kontena_pos/app_state.dart'; // Import for deep equality check
// import 'package:flutter/material.dart';
// import 'package:kontena_pos/models/cartitem.dart';

// enum CartMode {
//   update, // Update the quantity if the item already exists
//   add, // Add a new item if it doesn't exist
// }

// class Cart extends ChangeNotifier {
//   final AppState appState; // Dependency injection for AppState
//   VoidCallback? _onCartChanged;

//   Cart(this.appState, {VoidCallback? onCartChanged}) {
//     _onCartChanged = onCartChanged;
//   }

//   List<CartItem> get items => List.from(appState.cartItems);

//   double _totalPrice = 0.0;
//   double get totalPrice => _totalPrice;

//   // Fungsi untuk menghitung harga addon
//   int _calculateAddonsPrice(Map<String, Map<String, dynamic>>? addons) {
//     int total = 0;
//     if (addons != null) {
//       addons.forEach((addonCategory, addonDetails) {
//         if (addonDetails.containsKey('price')) {
//           total += addonDetails['price'] as int;
//         }
//       });
//     }
//     return total;
//   }

//   // Fungsi untuk menghitung ulang total harga
//   void _recalculateTotalPrice() {
//     _totalPrice =
//         appState.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
//     notifyListeners(); // Notify that total price has changed
//   }

//   // Fungsi untuk mencari index item berdasarkan ID dan variannya
//   int findItemIndex(CartItem newItem) {
//     return appState.cartItems.indexWhere((item) =>
//         item.id == newItem.id &&
//         item.variant == newItem.variant &&
//         item.preference.toString() == newItem.preference.toString() &&
//         item.addons.toString() == newItem.addons.toString());
//   }

//   // Menambahkan atau memperbarui item di cart
//   void addItem(CartItem newItem, {CartMode mode = CartMode.add}) {
//     final existingItemIndex = findItemIndex(newItem);

//     if (existingItemIndex >= 0) {
//       var existingItem = appState.cartItems[existingItemIndex];

//       if (mode == CartMode.add) {
//         existingItem.qty += newItem.qty;
//       } else if (mode == CartMode.update) {
//         existingItem.qty = newItem.qty;
//       }

//       // Update item yang ada dengan detail baru
//       existingItem = existingItem.copyWith(
//         variant: newItem.variant,
//         variantId: newItem.variantId,
//         itemName: newItem.itemName,
//         itemGroup: newItem.itemGroup,
//         notes: newItem.notes,
//         preference: newItem.preference,
//         addons: newItem.addons,
//         variantPrice: newItem.variantPrice,
//         addonsPrice: _calculateAddonsPrice(newItem.addons),
//       );

//       appState.cartItems[existingItemIndex] =
//           existingItem; // Update item di AppState
//     } else {
//       // Tambahkan item baru
//       appState.cartItems.add(CartItem.from(newItem));
//     }
//     print('Daftar item di keranjang:');
//     for (var item in appState.cartItems) {
//       print('Nama: ${item.name}, Qty: ${item.qty}');
//     }
//     _recalculateTotalPrice(); // Hitung ulang total harga
//     _onCartChanged?.call(); // Beritahu listener
//     notifyListeners(); // Beritahu listener bahwa ada perubahan pada Cart
//   }

//   void updateItem(int index, CartItem updatedItem) {
//     if (index >= 0 && index < appState.cartItems.length) {
//       appState.cartItems[index] = CartItem.from(updatedItem);
//       _recalculateTotalPrice();
//       _onCartChanged?.call();
//       notifyListeners();
//     } else {
//       print('Item to update not found in the cart');
//     }
//   }

//   // Menghapus item dari cart
//   void removeItem(int index) {
//     if (index < 0 || index >= appState.cartItems.length) {
//       print('Invalid index: $index');
//       return;
//     }
//     appState.cartItems.removeAt(index);
//     _recalculateTotalPrice();
//     _onCartChanged?.call();
//   }

//   // Membersihkan semua item di cart
//   void clearAllItems() {
//     appState.cartItems.clear();
//     _recalculateTotalPrice();
//     _onCartChanged?.call();
//     notifyListeners(); // Notify listeners
//   }

//   List<CartItem> getAllItemCart() {
//     return AppState().cartItems.toList();
//   }

//   // Mengecek apakah item ada di cart
//   bool isItemInCart(String itemId) {
//     return appState.cartItems.any((item) => item.id == itemId);
//   }

//   // Fungsi untuk membuat order
//   Future<void> createOrder({
//     required TextEditingController guestNameController,
//     required VoidCallback resetDropdown,
//     required VoidCallback onSuccess,
//   }) async {
//     // Periksa apakah nama pemesan dan cart tidak kosong
//     if (guestNameController.text.isEmpty) {
//       throw 'Nama pemesan tidak boleh kosong!';
//     }
//     if (appState.cartItems.isEmpty) {
//       throw 'Keranjang tidak boleh kosong!';
//     }

//     try {
//       // Buat order menggunakan OrderManager
//       await appState.orderManager.createOrder(
//         guestNameController: guestNameController,
//         resetDropdown: resetDropdown,
//         onSuccess: onSuccess,
//         cartItems: appState.cartItems, // Gunakan item dari AppState
//       );

//       // Setelah order berhasil, bersihkan keranjang dan reset form
//       clearAllItems();
//       guestNameController.clear();
//       resetDropdown();
//       // Setelah order berhasil, bersihkan keranjang dan reset form
//       clearAllItems();
//       guestNameController.clear();
//       resetDropdown();

//       // Callback sukses
//       onSuccess();
//       notifyListeners(); // Beritahu listener bahwa ada perubahan pada Cart
//     } catch (e) {
//       throw 'Error saat membuat order: $e';
//     }
//   }
// }
