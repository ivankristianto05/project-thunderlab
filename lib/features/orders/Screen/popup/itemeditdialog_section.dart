// import 'package:flutter/material.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:kontena_pos/core/functions/cart.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/variant_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/noteandpreference_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/addons_section.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/sumary_section.dart';
// import 'package:kontena_pos/data/menuvarian.dart';
// import 'package:kontena_pos/models/cartitem.dart';

// class ItemEditDialog extends StatefulWidget {
//   final int index;
//   final Cart cart;
//   final AppState appState;

//   ItemEditDialog({
//     required this.index,
//     required this.cart,
//     required this.appState,
//   });

//   @override
//   _ItemEditDialogState createState() => _ItemEditDialogState();
// }

// class _ItemEditDialogState extends State<ItemEditDialog> {
//   late CartItem _item;
//   int _selectedVariantIndex = -1;
//   String? _selectedVariantId;
//   int _selectedPreferenceIndex = -1;
//   String _selectedPreference = '';
//   Map<String, Map<String, dynamic>> _selectedAddons = {}; // Update here
//   String _notes = '';
//   int _quantity = 1;
//   int _variantPrice = 0;
//   String? _selectedVariant;
//   int _addonsTotalPrice = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFields();
//   }

//   void _initializeFields() {
//     _item = widget.cart.items[widget.index];
//     _selectedVariantId = _item.variantId;
//     _quantity = _item.qty;
//     _notes = _item.notes;
//     _selectedPreference = _item.preference['preference'] ?? '';

//     // Parse _item.addons from Map<String, dynamic> to the new Map<String, Map<String, dynamic>>
//     _selectedAddons = _item.addons ?? {};
//     _variantPrice = _item.variantPrice;

//     List<Map<String, dynamic>> filteredVariants =
//         MenuVarian.where((variant) => variant['id_menu'] == _item.id).toList();

//     List<String> variantNames = filteredVariants
//         .map((variant) => variant['nama_varian'] as String)
//         .toList();

//     _selectedVariantIndex = variantNames.indexOf(_item.variant ?? '');
//     _selectedPreferenceIndex = _getPreferenceIndex(_selectedPreference);
//     _calculateAddonsTotalPrice(); // Recalculate total price for addons
//   }

//   void _calculateAddonsTotalPrice() {
//     _addonsTotalPrice = _selectedAddons.values
//         .where((addon) => addon['selected'] == true)
//         .fold(0, (total, addon) => total + (addon['price'] as int));
//   }

//   void _editItem() {
//     List<Map<String, dynamic>> filteredVariants =
//         MenuVarian.where((variant) => variant['id_menu'] == _item.id).toList();
//     final selectedVariant = _selectedVariantIndex >= 0 &&
//             _selectedVariantIndex < filteredVariants.length
//         ? filteredVariants[_selectedVariantIndex]
//         : null;

//     _calculateAddonsTotalPrice(); // Recalculate the total price before saving

//     final editedItem = _item.copyWith(
//       variant: selectedVariant?['nama_varian'] ?? '',
//       variantId: selectedVariant?['id_varian'],
//       qty: _quantity,
//       addons: _selectedAddons, // Save addons in the new format
//       notes: _notes,
//       preference: {'preference': _selectedPreference},
//       variantPrice: _variantPrice,
//     );

//     widget.cart.updateItem(widget.index, editedItem);

//     // Ensure update in AppState
//     widget.appState.update(() {
//       // widget.appState.cartItems[widget.index] = editedItem;
//     });

//     Navigator.of(context).pop();
//   }

//   int _getPreferenceIndex(String preference) {
//     List<String> preferences = _getPreferencesBasedOnType();
//     return preferences.indexOf(preference);
//   }

//   List<String> _getPreferencesBasedOnType() {
//     switch (_item.type) {
//       case 'food':
//         return ['original', 'hot', 'very hot', 'no sauce', 'no MSG', 'no salt'];
//       case 'beverage':
//         return ['less sugar', 'less ice'];
//       case 'breakfast':
//         return ['small', 'medium', 'jumbo'];
//       default:
//         return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double popupWidth = MediaQuery.of(context).size.width * 0.9;
//     double popupHeight = MediaQuery.of(context).size.height * 0.7;

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Container(
//         width: popupWidth,
//         height: popupHeight,
//         child: Column(
//           children: [
//             _buildHeader(),
//             Divider(height: 1),
//             Expanded(child: _buildContent()),
//             _buildFooter(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Edit ${_item.name}',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return Row(
//       children: [
//         _buildVariantSection(),
//         _buildNotesAndPreferenceSection(),
//         _buildAddonSection(),
//         _buildSummarySection(),
//       ],
//     );
//   }

//   Widget _buildVariantSection() {
//     return Flexible(
//       flex: 2,
//       child: VariantSection(
//         idMenu: _item.id,
//         selectedIndex: _selectedVariantIndex,
//         onVariantSelected: (index, variant, price) {
//           setState(() {
//             _selectedVariantIndex = index;
//             _selectedVariant = variant;
//             _variantPrice = price;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildNotesAndPreferenceSection() {
//     return Flexible(
//       flex: 2,
//       child: NotesAndPreferenceSection(
//         type: _item.type ?? 'defaultType',
//         selectedPreferenceIndex: _selectedPreferenceIndex,
//         onPreferenceSelected: (index, preference) {
//           setState(() {
//             _selectedPreferenceIndex = index;
//             _selectedPreference = preference;
//           });
//         },
//         onNotesChanged: (notes) {
//           setState(() {
//             _notes = notes;
//           });
//         },
//         initialNotes: _item.notes,
//       ),
//     );
//   }

//   Widget _buildAddonSection() {
//     return Flexible(
//       flex: 2,
//       child: AddonSection(
//         type: _item.type ?? 'defaultType',
//         selectedAddons: _selectedAddons,
//         onAddonChanged: (addons) {
//           setState(() {
//             _selectedAddons = addons;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildSummarySection() {
//     return Flexible(
//       flex: 2,
//       child: SummarySection(
//         name: _item.name,
//         price: _variantPrice != 0 ? _variantPrice : _item.price,
//         type: _item.type ?? 'defaultType',
//         selectedVariant: _selectedVariant,
//         selectedPreferenceIndex: _selectedPreferenceIndex,
//         selectedAddons: _selectedAddons,
//         notes: _notes,
//         quantity: _quantity,
//         onQuantityChanged: (quantity) {
//           setState(() {
//             _quantity = quantity;
//           });
//         },
//         variantPrice: _variantPrice,
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       height: 50,
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor:
//                 MaterialStateProperty.all<Color>(const Color(0xFF00ADB5)),
//           ),
//           onPressed: _editItem,
//           child: Text(
//             'Save Changes',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
