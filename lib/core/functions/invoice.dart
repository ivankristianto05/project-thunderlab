import 'dart:ui';

import 'package:kontena_pos/app_state.dart';

enum InvoiceCartMode {
  update, // Update the quantity if the item already exists
  add, // Add a new item if it doesn't exist
}

class InvoiceCartItem {
  final String id;
  final String name;
  final String itemName;
  final String itemGroup;
  final String? uom;
  final String description;
  int qty;
  final Map<String, String> preference;
  final int price;
  late int totalPrice;
  final int totalAddon;
  String? notes;
  List<dynamic>? addon;
  bool? status;
  String? cartId;
  int docstatus;

  InvoiceCartItem({
    required this.id,
    required this.name,
    required this.itemName,
    required this.itemGroup,
    required this.qty,
    required this.preference,
    required this.price,
    this.uom,
    required this.description,
    this.notes,
    this.addon,
    this.status,
    this.cartId,
    required this.docstatus,
    required this.totalAddon,
  }) {
    totalPrice = qty * price;
  }
}

class InvoiceCart {
  List<InvoiceCartItem> _items = [];
  VoidCallback? _onCartChanged;
  InvoiceCart({VoidCallback? onCartChanged}) : _onCartChanged = onCartChanged {
    // Set the initial cart items from AppState
    _items = List.from(AppState.invoiceCartItems);
  }

  List<InvoiceCartItem> get items => List.from(_items);

  void _recalculateTotalPrice() {
    for (var item in _items) {
      if (item.docstatus != 2) {
        item.totalPrice = item.qty * (item.price + item.totalAddon);
      }
    }
  }

  void addItem(InvoiceCartItem newItem,
      {InvoiceCartMode mode = InvoiceCartMode.add}) {
    // Check if the item with the same ID already exists
    var existingItem = _items.firstWhere(
      (item) => item.id == newItem.id,
      orElse: () => InvoiceCartItem(
        id: '',
        name: '',
        qty: 0,
        price: 0,
        itemName: '',
        itemGroup: '',
        preference: {},
        addon: [],
        notes: '',
        uom: '',
        description: '',
        status: false,
        cartId: '',
        docstatus: 0,
        totalAddon: 0,
      ),
    ); // Return an empty CartItem if not found

    if (existingItem.id.isNotEmpty) {
      // Item already exists, update the quantity
      if (mode == InvoiceCartMode.add) {
        existingItem.qty += newItem.qty;
        existingItem.notes = newItem.notes;
      } else {
        // Default behavior: Add a new item
        existingItem.qty = newItem.qty;
        existingItem.notes = newItem.notes;
      }
    } else {
      // Item doesn't exist, add a new item
      _items.add(newItem);
    }

    // Recalculate total price
    _recalculateTotalPrice();

    // Notify changes
    _onCartChanged?.call();

    // Update app state
    AppState.updateInvoiceCart(_items);
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);

    // Recalculate total price
    _recalculateTotalPrice();

    // Notify changes
    _onCartChanged?.call();

    // Update app state
    AppState.updateInvoiceCart(_items);
  }

  void clearCart() {
    _items.clear();

    // Recalculate total price
    _recalculateTotalPrice();

    // Notify changes
    _onCartChanged?.call();

    // Update app state
    AppState.updateInvoiceCart(_items);
  }

  bool isItemInCart(String itemId) {
    return AppState.invoiceCartItems.any((item) => item.id == itemId);
  }

  Map<String, dynamic> getItemCart(String itemName) {
    List<InvoiceCartItem> data = [];
    Map<String, int> indexes = {};

    int index = 0;
    for (var item in AppState.invoiceCartItems) {
      if (item.name == itemName) {
        indexes[item.id] = index;
        data.add(item);
      }
      index++;
    }

    return {"data": data, "index": indexes};

    // return {
    //   "index": indexes,
    //   "data": result
    // }

    // return AppState.cartItems
    //     .where((item) => item.name == itemName)
    //     .toList();
  }

  InvoiceCartItem getItemByIndex(int index) {
    return AppState.invoiceCartItems[index];
  }

  List<InvoiceCartItem> getAllItemCart() {
    return AppState.invoiceCartItems.toList();
  }

  Map<String, dynamic> recapCart() {
    // Summarize quantities and total price based on item names
    Map<String, dynamic> recap = {
      'totalPrice': 0,
      'totalItem': 0,
      'items': {},
    };

    for (var item in AppState.invoiceCartItems) {
      recap['totalPrice'] += item.docstatus != 2 ? item.totalPrice : 0;

      if (!recap['items'].containsKey(item.name)) {
        recap['items'][item.name] = {
          'name': item.itemName,
          'preference': item.preference,
          'totalQty': item.qty,
          'totalPrice': item.totalPrice,
          'notes': item.notes,
          'addon': item.addon,
        };
        recap['totalItem'] += 1;
      } else {
        recap['items'][item.name]['totalQty'] += item.qty;
        recap['items'][item.name]['totalPrice'] += item.totalPrice;
      }
    }

    return recap;
  }
}

String getPreferenceText(Map<String, String> data) {
  // Get the values from the map
  List<String> values = data.values.cast<String>().toList();

  // Join the values into a comma-separated string
  String result = values.join(', ');

  return result;
}
