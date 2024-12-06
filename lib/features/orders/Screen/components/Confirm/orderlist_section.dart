// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/models/list_to_confirm.dart';
// import 'package:kontena_pos/app_state.dart';

// class OrderList extends StatefulWidget {
//   final List<dynamic> listorder;
//   final double screenWidth;
//   final AppState appState;
//   final ValueChanged<bool>? onAllChecked;
//   final String currentOrderId;

//   const OrderList({
//     Key? key,
//     required this.listorder,
//     required this.screenWidth,
//     required this.appState,
//     this.onAllChecked, // Optional
//     required this.currentOrderId,
//   }) : super(key: key);

//   @override
//   _OrderListState createState() => _OrderListState();
// }

// class _OrderListState extends State<OrderList> {
//   Map<String, bool> checkedItems = {};

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final currentOrderId = widget.currentOrderId;
//       if (currentOrderId.isNotEmpty) {
//         // Load the saved item checked statuses
//         await widget.appState.loadAndSetItemCheckedStatuses(currentOrderId);
//         setState(() {
//           checkedItems = widget.appState.getItemCheckedStatuses(currentOrderId);
//         });

//         // Optionally check if all items are checked
//         _checkAllCheckedStatus();
//       }
//     });
//   }

//   void _checkAllCheckedStatus() {
//     final currentOrderId = widget.currentOrderId;
//     final allChecked = widget.listorder
//         .firstWhere((order) => order.idOrder == currentOrderId)
//         .items
//         .every((item) => checkedItems['${currentOrderId}-${item.id}'] ?? false);

//     if (widget.onAllChecked != null) {
//       widget.onAllChecked!(allChecked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentOrderId = widget.currentOrderId;
//     final filteredList = widget.listorder
//         .where((order) => order.idOrder == currentOrderId)
//         .toList();

//     return Container(
//       width: widget.screenWidth * 0.3,
//       child: filteredList.isEmpty
//           ? Center(
//               child: Text(
//                 currentOrderId.isEmpty
//                     ? 'No Order Selected'
//                     : 'Order ID: $currentOrderId not found',
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//           : Consumer<AppState>(
//               builder: (context, appState, child) {
//                 return ListView.separated(
//                   itemCount: filteredList.length,
//                   separatorBuilder: (context, index) => Divider(
//                     thickness: 1.5,
//                     color: Colors.grey[800],
//                   ),
//                   itemBuilder: (context, index) {
//                     final listItem = filteredList[index];

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           for (int i = 0; i < listItem.items.length; i++) ...[
//                             if (i > 0)
//                               Divider(
//                                 thickness: 1.0,
//                                 color: Colors.grey[400],
//                               ),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${listItem.items[i].qty}',
//                                   style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '${listItem.items[i].name} - ${listItem.items[i].variant ?? ''}',
//                                         style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       if (listItem.items[i]
//                                               .preference['preference'] !=
//                                           null)
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 4.0),
//                                           child: Text(
//                                             'Preference: ${listItem.items[i].preference['preference']!}',
//                                             style: const TextStyle(
//                                                 fontSize: 13,
//                                                 color: textdetailcolor,
//                                                 fontWeight: FontWeight.w800),
//                                           ),
//                                         ),
//                                       if (listItem.items[i].addons != null &&
//                                           listItem.items[i]
//                                               .addons!
//                                               .isNotEmpty)
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 4.0),
//                                           child: Text(
//                                             'Addons: ${listItem.items[i].addons!.entries.where((addon) => addon.value['selected'] == true).map((addon) => addon.key).join(', ')}',
//                                             style: const TextStyle(
//                                                 fontSize: 13,
//                                                 color: textdetailcolor,
//                                                 fontWeight: FontWeight.w800),
//                                           ),
//                                         ),
//                                       if (listItem.items[i].notes.isNotEmpty)
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 4.0),
//                                           child: Text(
//                                             'Notes: ${listItem.items[i].notes}',
//                                             style: const TextStyle(
//                                                 fontSize: 13,
//                                                 color: textdetailcolor,
//                                                 fontWeight: FontWeight.w800),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                                 Checkbox(
//                                   value: appState.isItemChecked(
//                                       currentOrderId, listItem.items[i].id),
//                                   onChanged: (bool? value) {
//                                     appState.setItemCheckedStatus(
//                                       currentOrderId,
//                                       listItem.items[i].id,
//                                       value ?? false,
//                                     );
//                                     _checkAllCheckedStatus();
//                                   },
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: buttonselectedcolor,
//                                     padding:
//                                         const EdgeInsets.symmetric(horizontal: 16),
//                                   ),
//                                   onPressed: () {},
//                                   child: const Text(
//                                     'Edit',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: redcolor,
//                                     padding:
//                                         const EdgeInsets.symmetric(horizontal: 16),
//                                   ),
//                                   onPressed: () {},
//                                   child: const Text(
//                                     'Delete',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 14),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
