// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:kontena_pos/core/functions/cart.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/addons_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/noteandpreference_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/sumary_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/variant_section.dart';
// import 'package:kontena_pos/data/menuvarian.dart';
// import 'package:kontena_pos/models/cartitem.dart';
// import 'package:provider/provider.dart';
// import 'package:kontena_pos/app_state.dart';

// class ConfirmInputDetail extends StatefulWidget {
//   final String name;
//   final int price;
//   final String idMenu;
//   final String type;

//   ConfirmInputDetail({
//     required this.name,
//     required this.price,
//     required this.idMenu,
//     required this.type,
//   });

//   @override
//   _ConfirmInputDetailState createState() => _ConfirmInputDetailState();
// }

// class _ConfirmInputDetailState extends State<ConfirmInputDetail> {
//   int _selectedVariantIndex = -1;
//   int _selectedPreferenceIndex = -1;
//   String _selectedPreference = '';
//   Map<String, Map<String, dynamic>> _selectedAddons = {}; // Updated to match the AddonSection type
//   String _notes = '';
//   String? _selectedVariant;
//   int _quantity = 1;
//   int _variantPrice = 0;

//   final NumberFormat currencyFormat = NumberFormat('#,###', 'id_ID');

//   void _addItemToCart() {
//     final List<Map<String, dynamic>> filteredVariants = MenuVarian
//       .where((variant) => variant['id_menu'] == widget.idMenu)
//       .toList();

//     final selectedVariant = _selectedVariantIndex >= 0 && _selectedVariantIndex < filteredVariants.length
//         ? filteredVariants[_selectedVariantIndex]
//         : null;

//     final cartItem = CartItem(
//       id: widget.idMenu,
//       name: widget.name,
//       variant: selectedVariant != null ? selectedVariant['nama_varian'] : null,
//       variantId: selectedVariant != null ? selectedVariant['id_varian'] : null,
//       qty: _quantity,
//       price: widget.price,
//       variantPrice: _variantPrice,
//       addons: _selectedAddons, // No need to convert, already the right type
//       notes: _notes,
//       preference: {
//         'preference': _selectedPreference,
//       },
//       type: widget.type,
//     );

//     final cart = Provider.of<Cart>(context, listen: false);
//     cart.addItem(cartItem);

//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Column(
//       children: [
//         // AppBar
//         Container(
//           color: Colors.white,
//           height: screenHeight * 0.08,
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 widget.name,
//                 style: TextStyle(color: Colors.black, fontSize: 20),
//               ),
//             ],
//           ),
//         ),
//         // Detail Page
//         Expanded(
//           child: Row(
//             children: [
//               Expanded(
//                 child: VariantSection(
//                   idMenu: widget.idMenu,
//                   selectedIndex: _selectedVariantIndex,
//                   onVariantSelected: (index, variant, price) {
//                     setState(() {
//                       _selectedVariantIndex = index;
//                       _selectedVariant = variant;
//                       _variantPrice = price;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: NotesAndPreferenceSection(
//                   type: widget.type,
//                   selectedPreferenceIndex: _selectedPreferenceIndex,
//                   onPreferenceSelected: (index, preference) {
//                     setState(() {
//                       _selectedPreferenceIndex = index;
//                       _selectedPreference = preference;
//                     });
//                   },
//                   onNotesChanged: (notes) {
//                     setState(() {
//                       _notes = notes;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: AddonSection(
//                   type: widget.type,
//                   selectedAddons: _selectedAddons, // Updated type
//                   onAddonChanged: (addons) {
//                     setState(() {
//                       _selectedAddons = addons;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: SummarySection(
//                   name: widget.name,
//                   price: _variantPrice != 0 ? _variantPrice : widget.price,
//                   type: widget.type,
//                   selectedVariant: _selectedVariant,
//                   selectedPreferenceIndex: _selectedPreferenceIndex,
//                   selectedAddons: _selectedAddons,
//                   notes: _notes,
//                   quantity: _quantity,
//                   onQuantityChanged: (quantity) {
//                     setState(() {
//                       _quantity = quantity;
//                     });
//                   },
//                   variantPrice: _variantPrice,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
