// import 'package:flutter/material.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/itemeditdialog_section.dart';
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/core/functions/cart.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:intl/intl.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:kontena_pos/models/cartitem.dart';
// import 'package:provider/provider.dart';

// class ItemCart extends StatelessWidget {
//   final List<CartItem> cartItems;
//   final double screenWidth;
//   final void Function(CartItem editedItem) onEditItem;
//   final AppState appState; // Include appState
//   final Cart cart; // Include the cart

//   ItemCart({
//     required this.cartItems,
//     required this.screenWidth,
//     required this.onEditItem,
//     required this.appState,
//     required this.cart,
//   });

//   final NumberFormat currencyFormat = NumberFormat('###');

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cart>(context);
//     final cartItems = cart.items; // Mendapatkan item cart dari Cart
//     return Container(
//       width: screenWidth * 0.3,
//       child: ListView.separated(
//         itemCount: cartItems.length,
//         separatorBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Divider(thickness: 3),
//         ),
//         itemBuilder: (context, index) {
//           final item = cartItems[index];
//           final price = item.variantPrice != 0 ? item.variantPrice : item.price;

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Quantity and Name-Variant
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Quantity
//                     Text(
//                       '${item.qty}x ',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     // Name and Variant
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${item.name} - ${item.variant ?? ''}',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 8),
//                 // Dotted Divider Line
//                 DottedLine(
//                   dashColor: Colors.grey,
//                   lineThickness: 1.0,
//                   dashLength: 4.0,
//                   dashGapLength: 4.0,
//                 ),
//                 SizedBox(height: 8),
//                 // Quantity x Price
//                 Text(
//                   '${item.qty} x Rp ${currencyFormat.format(price)}',
//                   style: TextStyle(
//                       fontSize: 13,
//                       color: textdetailcolor,
//                       fontWeight: FontWeight.w800),
//                 ),
//                 SizedBox(height: 8),
//                 // Preference
//                 if (item.preference['preference'] != null &&
//                     item.preference['preference']!.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       'Preference: ${item.preference['preference']!}',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: textdetailcolor,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 // Addons
//                 if (item.addons != null && item.addons!.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       'Addons: ${item.addons!.entries.where((addon) => addon.value['selected'] == true).map((addon) => addon.key).join(', ')}',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: textdetailcolor,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 // Notes
//                 if (item.notes.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       'Notes: ${item.notes}',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: textdetailcolor,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: buttonselectedcolor,
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) => ItemEditDialog(
//                             index: cartItems.indexOf(item),
//                             cart: cart,
//                             appState: appState,
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Edit',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: redcolor,
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       onPressed: () {
//                         cart.removeItem(index);
//                         appState.update(() {
//                           // appState.cartItems.remove(item);
//                         });
//                       },
//                       child: Text(
//                         'Delete',
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
