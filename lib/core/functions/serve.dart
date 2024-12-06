// import 'package:flutter/material.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:kontena_pos/core/functions/order.dart';
// import 'package:kontena_pos/models/list_to_serve.dart';

// class ServeManager extends ChangeNotifier {
//   List<ListToServe> _serveOrders = [];
//   List<ListToServe> get serveOrders => _serveOrders;

//   // Variabel untuk menyimpan currentOrderId yang unik untuk ServeManager
//   String _currentServeOrderId = '';
//   String get currentServeOrderId => _currentServeOrderId;

//   void setCurrentServeOrderId(String orderId) {
//     _currentServeOrderId = orderId;
//     notifyListeners();
//   }

//   final AppState appState;
//   final OrderManager orderManager;

//   ServeManager(this.appState, this.orderManager);

//   // Method untuk menambahkan confirmed order ke served list
//   void addServedOrder(String orderId) {
//     // Dapatkan order dari confirmed orders di OrderManager
//     final confirmedOrder = orderManager.getConfirmedOrderById(orderId);

//     if (confirmedOrder.idOrder.isNotEmpty) {
//       // Buat ListToServe berdasarkan confirmed order
//       ListToServe servedOrder = ListToServe(
//         idOrder: confirmedOrder.idOrder,
//         namaPemesan: confirmedOrder.namaPemesan,
//         table: confirmedOrder.table,
//         items: confirmedOrder.items, // Menggunakan items dari confirmed order
//         time: confirmedOrder.time,
//       );

//       // Tambahkan ke daftar servedOrders
//       _serveOrders.add(servedOrder);
//       //_currentServeOrderId = confirmedOrder.idOrder;
//       notifyListeners(); // Beritahu UI bahwa data berubah
//     } else {
//       print('Order dengan ID $orderId tidak ditemukan.');
//     }
//   }

//   // Fungsi untuk memilih pesanan yang ada dan mengatur currentOrderId
//   void selectServeOrder(String orderId) {
//     // Cari pesanan dengan orderId yang diberikan
//     final selectedOrder = _serveOrders.firstWhere(
//       (order) => order.idOrder == orderId,
//       orElse: () => ListToServe(
//         idOrder: '',
//         namaPemesan: '',
//         table: '',
//         items: [],
//         time: DateTime.now(),
//       ),
//     );

//     if (selectedOrder.idOrder.isNotEmpty) {
//       // Jika pesanan ditemukan, atur currentOrderId ke ID pesanan tersebut
//       _currentServeOrderId = selectedOrder.idOrder;
//     } else {
//       print('Pesanan dengan ID $orderId tidak ditemukan.');
//     }

//     notifyListeners(); // Beritahu UI bahwa currentOrderId telah berubah
//   }

//   // Fungsi untuk mendapatkan pesanan yang sedang dipilih berdasarkan currentOrderId
//   ListToServe getCurrentOrder() {
//     // Cari pesanan berdasarkan currentOrderId
//     return _serveOrders.firstWhere(
//       (order) => order.idOrder == _currentServeOrderId,
//       orElse: () => ListToServe(
//         idOrder: '',
//         namaPemesan: '',
//         table: '',
//         items: [],
//         time: DateTime.now(),
//       ),
//     );
//   }

//   // Fungsi untuk menghapus pesanan berdasarkan currentOrderId
//   void removeCurrentOrder() {
//     _serveOrders.removeWhere((order) => order.idOrder == _currentServeOrderId);

//     // Reset currentOrderId setelah pesanan dihapus
//     if (_serveOrders.isNotEmpty) {
//       _currentServeOrderId =
//           _serveOrders.last.idOrder; // Pilih pesanan terakhir
//     } else {
//       _currentServeOrderId = ''; // Tidak ada pesanan yang tersisa
//     }

//     notifyListeners();
//   }

//   // Fungsi untuk mengosongkan semua pesanan yang disajikan
//   void clearServeOrders() {
//     _serveOrders.clear();
//     _currentServeOrderId = ''; // Reset currentOrderId
//     notifyListeners();
//   }
// }
