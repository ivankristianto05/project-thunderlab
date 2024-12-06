// import 'package:flutter/material.dart';
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/core/functions/cart.dart';
// import 'package:kontena_pos/models/list_to_confirm.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:provider/provider.dart';

// class ServeList extends StatefulWidget {
//   final List<ListToConfirm> listToConfirm;
//   final double screenWidth;
//   final AppState appState;
//   final ValueChanged<bool>? onAllChecked; // Optional

//   ServeList({
//     required this.listToConfirm,
//     required this.screenWidth,
//     required this.appState,
//     this.onAllChecked, // Optional
//   });

//   @override
//   _ServeListState createState() => _ServeListState();
// }

// class _ServeListState extends State<ServeList> {
//   Map<String, bool> checkedItems = {};

//   void _checkAllCheckedStatus() {
//     final currentOrderId = widget.appState.currentOrderId;
//     final allChecked = widget.listToConfirm
//         .firstWhere((order) => order.idOrder == currentOrderId)
//         .items
//         .every((item) => checkedItems['${currentOrderId}-${item.id}'] ?? false);
//     if (widget.onAllChecked != null) {
//       widget.onAllChecked!(allChecked);
//     }
//   }

//  @override
// void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//         final currentOrderId = widget.appState.currentOrderId;
//         if (currentOrderId.isNotEmpty) {
//             // Load the saved item checked statuses
//             await widget.appState.loadAndSetItemCheckedStatuses(currentOrderId);
//             setState(() {
//                 checkedItems = widget.appState.getItemCheckedStatuses(currentOrderId);
//             });

//             // Optionally check if all items are checked and update checkedItems accordingly
//             final allChecked = widget.listToConfirm
//                 .firstWhere((order) => order.idOrder == currentOrderId)
//                 .items
//                 .every((item) => checkedItems['${currentOrderId}-${item.id}'] ?? false);
                
//             // Call onAllChecked if needed
//             if (widget.onAllChecked != null) {
//                 widget.onAllChecked!(allChecked);
//             }
//         }
//     });
// }

//  @override
// Widget build(BuildContext context) {
//   final currentOrderId = widget.appState.currentOrderId;
//   final filteredList = widget.listToConfirm
//       .where((order) => order.idOrder == currentOrderId)
//       .toList();

//   return Container(
//     width: widget.screenWidth * 0.3,
//     child: filteredList.isEmpty
//         ? Center(
//             child: Text(
//               currentOrderId.isEmpty
//                   ? 'No Order Selected'
//                   : 'Order ID: $currentOrderId not found',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           )
//         : Consumer<AppState>(
//             builder: (context, appState, child) {
//               return ListView.separated(
//                 itemCount: filteredList.length,
//                 separatorBuilder: (context, index) =>
//                     Divider(thickness: 1.5, color: Colors.grey[800]),
//                 itemBuilder: (context, index) {
//                   final listItem = filteredList[index];

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 8.0, horizontal: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         for (int i = 0; i < listItem.items.length; i++) ...[
//                           if (i > 0)
//                             Divider(
//                               thickness: 1.0,
//                               color: Colors.grey[400],
//                             ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${listItem.items[i].qty}', // Display qty on the left
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(width: 8), // Space between qty and name-variant
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${listItem.items[i].name} - ${listItem.items[i].variant ?? ''}',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     // Display additional information like preferences, addons, and notes
//                                     if (listItem.items[i].preference['preference'] != null &&
//                                         listItem.items[i].preference['preference']!.isNotEmpty)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4.0),
//                                         child: Text(
//                                           'Preference: ${listItem.items[i].preference['preference']!}',
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               color: textdetailcolor,
//                                               fontWeight: FontWeight.w800),
//                                         ),
//                                       ),
//                                     if (listItem.items[i].addons != null &&
//                                         listItem.items[i].addons!.isNotEmpty)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4.0),
//                                         child: Text(
//                                           'Addons: ${listItem.items[i].addons!.entries.where((addon) => addon.value['selected'] == true).map((addon) => addon.key).join(', ')}',
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               color: textdetailcolor,
//                                               fontWeight: FontWeight.w800),
//                                         ),
//                                       ),
//                                     if (listItem.items[i].notes.isNotEmpty)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4.0),
//                                         child: Text(
//                                           'Notes: ${listItem.items[i].notes}',
//                                           style: TextStyle(
//                                               fontSize: 13,
//                                               color: textdetailcolor,
//                                               fontWeight: FontWeight.w800),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               Checkbox(
//                                 value: appState.isItemChecked(currentOrderId, listItem.items[i].id),
//                                 onChanged: (bool? value) {
//                                   appState.setItemCheckedStatus(
//                                     currentOrderId,
//                                     listItem.items[i].id,
//                                     value ?? false,
//                                   );
//                                   // Re-check all items' checked status after change
//                                   _checkAllCheckedStatus();
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: buttonselectedcolor,
//                                   padding: EdgeInsets.symmetric(horizontal: 16),
//                                 ),
//                                 onPressed: () {},
//                                 child: Text(
//                                   'Edit',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: redcolor,
//                                   padding: EdgeInsets.symmetric(horizontal: 16),
//                                 ),
//                                 onPressed: () {},
//                                 child: Text(
//                                   'Delete',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//   );
// }
// }