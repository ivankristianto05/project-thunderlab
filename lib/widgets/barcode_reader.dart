import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

class barcodeReader extends StatelessWidget {
  final dynamic Function(String type) onScannerReader;

  barcodeReader({required this.onScannerReader});

  @override
  Widget build(BuildContext context) {
    return BarcodeKeyboardListener(
      bufferDuration: Duration(milliseconds: 200),
      onBarcodeScanned: onScannerReader,
      child: Container(),
    );
  }
}
