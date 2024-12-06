// import 'package:flutter/foundation.dart';
// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';

// class PrinterState with ChangeNotifier {
//   BluetoothDevice? _selectedPrinter;
//   bool _isConnected = false;

//   BluetoothDevice? get selectedPrinter => _selectedPrinter;
//   bool get isConnected => _isConnected;

//   void selectPrinter(BluetoothDevice printer) {
//     _selectedPrinter = printer;
//     notifyListeners();
//   }

//   void setConnectionStatus(bool status) {
//     _isConnected = status;
//     notifyListeners();
//   }

//   void clearPrinter() {
//     _selectedPrinter = null;
//     _isConnected = false;
//     notifyListeners();
//   }
// }
