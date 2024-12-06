class CartItem {
  final String id;
  final String name;
  String? itemGroup;
  String? itemName;
  String? variant;
  String? variantId;
  List<dynamic>? pref;
  List<dynamic>? addon;
  int qty;
  final int price;
  int variantPrice;
  int totalPrice;
  int addonsPrice; // Field to store the total price of addons

  Map<String, Map<String, dynamic>>? addons;
  String notes;
  Map<String, String> preference;
  String? type;

  CartItem({
    required this.id,
    required this.name,
    this.itemGroup,
    this.itemName,
    this.variant,
    this.variantId,
    required this.qty,
    required this.price,
    this.variantPrice = 0,
    this.addonsPrice = 0, // Initialize with 0
    this.addons,
    required this.notes,
    required this.preference,
    this.pref,
    this.addon,
    this.type,
  }) : totalPrice =
            qty * ((variantPrice != 0 ? variantPrice : price) + addonsPrice);

  // Constructor for creating a copy of an existing CartItem
  CartItem.from(CartItem item)
      : id = item.id,
        name = item.name,
        variant = item.variant,
        variantId = item.variantId,
        itemName = item.itemName,
        itemGroup = item.itemGroup,
        qty = item.qty,
        price = item.price,
        variantPrice = item.variantPrice,
        addonsPrice = item.addonsPrice, // Copy addonsPrice
        totalPrice = item.totalPrice,
        addons = item.addons != null ? Map.from(item.addons!) : null,
        notes = item.notes,
        preference = Map.from(item.preference),
        type = item.type;

  // Method to copy with modifications
  CartItem copyWith({
    String? variant,
    String? variantId,
    int? qty,
    int? variantPrice,
    int? addonsPrice, // Add addonsPrice to copyWith
    Map<String, Map<String, dynamic>>? addons,
    String? notes,
    Map<String, String>? preference,
    String? itemName,
    String? itemGroup,
  }) {
    // Recalculate total price if qty, variantPrice, or addonsPrice is modified
    return CartItem(
      id: id,
      name: name,
      itemName: itemName,
      itemGroup: itemGroup,
      variant: variant ?? this.variant,
      variantId: variantId ?? this.variantId,
      qty: qty ?? this.qty,
      price: price,
      variantPrice: variantPrice ?? this.variantPrice,
      addonsPrice: addonsPrice ?? this.addonsPrice, // Copy addonsPrice
      addons: addons ?? this.addons,
      notes: notes ?? this.notes,
      preference: preference ?? this.preference,
      type: type,
    )..calculateTotalPrice(); // Recalculate totalPrice after copying
  }

  // Method to calculate total price (qty * (variantPrice or price) + addonsPrice)
  void calculateTotalPrice() {
    totalPrice = qty * (variantPrice != 0 ? variantPrice : price) + addonsPrice;
  }

  // Method to convert CartItem to a Map with specific fields only
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'itemName': itemName,
      'itemGroup': itemGroup,
      'variant': variant,
      'variantId': variantId,
      'qty': qty,
      'addons': addons,
      'notes': notes,
      'preference': preference,
      'type': type,
    };
  }
}
