import 'dart:async';
import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, Color backgroundColor) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      left: 20.0, // Posisi kiri bawah
      bottom: 20.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Agar ukuran sekecil mungkin
            children: [
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                onPressed: () {
                  overlayEntry?.remove(); // Menutup toast secara manual
                  overlayEntry = null;
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Menambahkan ke Overlay
  Overlay.of(context)?.insert(overlayEntry!);

  // Menutup toast otomatis setelah 5 detik
  Timer(const Duration(seconds: 5), () {
    overlayEntry?.remove();
    overlayEntry = null;
  });
}

// Fungsi untuk menampilkan error toast
void alertError(BuildContext context, String message) {
  showToast(context, message, Colors.red);
}

// Fungsi untuk menampilkan success toast
void alertSuccess(BuildContext context, String message) {
  showToast(context, message, Colors.green);
}

// Fungsi untuk menampilkan modal toast failed sebagai toast
void alertModalFailed(BuildContext context, String message) {
  showToast(context, message, Colors.orange);
}
