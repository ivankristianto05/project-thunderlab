import 'package:kontena_pos/models/cartitem.dart';

class ListToConfirm {
  final String idOrder;
  final String namaPemesan;
  final String table;
  final List<CartItem> items;
  final String status; // Status field
  final Map<String, bool> itemCheckedStatuses; // Field for item checked statuses
  final DateTime time; // New field for time
  
  ListToConfirm({
    required this.idOrder,
    required this.namaPemesan,
    required this.table,
    required this.items,
    this.status = 'Draft', // Default to 'Draft'
    Map<String, bool>? itemCheckedStatuses, // Parameter for item checked statuses
    DateTime? time, // New parameter for time
  })  : itemCheckedStatuses = itemCheckedStatuses ?? {},
        time = time ?? DateTime.now(); // Default to current time if not provided

  // Method to copy the model with updated fields
  ListToConfirm copyWith({
    String? status,
    Map<String, bool>? itemCheckedStatuses,
    DateTime? time,
  }) {
    return ListToConfirm(
      idOrder: this.idOrder,
      namaPemesan: this.namaPemesan,
      table: this.table,
      items: this.items,
      status: status ?? this.status,
      itemCheckedStatuses: itemCheckedStatuses ?? this.itemCheckedStatuses,
      time: time ?? this.time,
    );
  }

  // Method to convert the model to a map format
  Map<String, dynamic> toMap() {
    return {
      'idOrder': idOrder,
      'namaPemesan': namaPemesan,
      'table': table,
      'status': status, // Include status in the map
      'itemCheckedStatuses': itemCheckedStatuses, // Include itemCheckedStatuses in the map
      'time': time.toIso8601String(), // Convert time to ISO8601 string
    };
  }

  // Method to create the model from a map format
  factory ListToConfirm.fromMap(Map<String, dynamic> map) {
    return ListToConfirm(
      idOrder: map['idOrder'],
      namaPemesan: map['namaPemesan'],
      table: map['table'],
      items: List<CartItem>.from(
        [],
      ),
      status: map['status'] ?? 'Draft', // Ensure status defaults to 'Draft'
      itemCheckedStatuses: Map<String, bool>.from(map['itemCheckedStatuses'] ?? {}),
      time: DateTime.parse(map['time'] ?? DateTime.now().toIso8601String()), // Parse time from string
    );
  }
}
