List<dynamic> ReformatItemWithPrice(
  List<dynamic> item,
  List<dynamic> itemPrice,
) {
  List<dynamic> result = [];
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);
  print('check data item, ${item.length}');
  print('check data item price, ${itemPrice.length}');

  for (var i in item) {
    var matchedPrice = itemPrice.firstWhere(
      (p) => p['item_code'] == i['item_code'],
      orElse: () => null,
    );
    // Only add item to result if there is a matched price
    if (matchedPrice != null) {
      i['price_list_rate'] = matchedPrice['price_list_rate'];
      result.add(i);
    }
  }
  return result;
}
