// // import 'package:flutter/material.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/Confirm/iconbutton_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/ordercard_section.dart';
// // import 'package:kontena_pos/widgets/top_bar.dart';
// // import 'package:provider/provider.dart';
// // import 'package:kontena_pos/app_state.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/custombutton_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/Confirm/orderlist_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/dropdown_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/guestname_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/footer_section.dart';
// // import 'package:kontena_pos/features/orders/Screen/components/searchbar_section.dart';
// // import 'package:kontena_pos/constants.dart';

// // class ConfirmScreen extends StatefulWidget {
// //   @override
// //   _ConfirmScreenState createState() => _ConfirmScreenState();
// // }

// // class _ConfirmScreenState extends State<ConfirmScreen> {
// //   final TextEditingController _guestNameController = TextEditingController();
// //   String _selectedFilterType = 'All';
// //   String _searchQuery = '';
// //   bool allItemsChecked = false; // To track if all items are checked

// //   @override
// //   void initState() {
// //     super.initState();
// //     _guestNameController.addListener(_handleTextChanged);
// //   }

// //   @override
// //   void dispose() {
// //     _guestNameController.removeListener(_handleTextChanged);
// //     _guestNameController.dispose();
// //     super.dispose();
// //   }

// //   void _handleTextChanged() {
// //     // Optionally debounce the input change
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       // Implement debouncing if needed to avoid frequent state updates
// //       setState(() {
// //         // Update your state here if needed
// //       });
// //     });
// //   }

// //   void _handleFilterSelected(String type) {
// //     setState(() {
// //       _selectedFilterType = type;
// //     });
// //   }

// //   void _handleSearchChanged(String query) {
// //     setState(() {
// //       _searchQuery = query;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final appState = Provider.of<AppState>(context);
// //     double screenWidth = MediaQuery.of(context).size.width;
// //     double searchbarWidth = screenWidth * 0.65;
// //     double smallButtonWidth = screenWidth * 0.05;
// //     double buttonWidth = screenWidth * 0.15;

// //     return Scaffold(
// //       // appBar: BuildAppbar(
// //       //   smallButtonWidth: smallButtonWidth,
// //       //   buttonWidth: buttonWidth,
// //       // ),
// //       body: Container(
// //         color: itembackgroundcolor,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TopBar(),
// //             Row(
// //               children: [
// //                 Container(
// //                   height: 55,
// //                   child: Searchbar(
// //                     screenWidth: searchbarWidth,
// //                     onSearchChanged: _handleSearchChanged,
// //                   ),
// //                 ),
// //                 GuestNameTextFieldButton(
// //                   screenWidth: screenWidth,
// //                   guestNameController: _guestNameController,
// //                   smallButtonWidth: smallButtonWidth,
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               children: [
// //                 Container(
// //                   width: searchbarWidth,
// //                 ),
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     border: Border(
// //                       top: BorderSide(
// //                         color: Colors.grey,
// //                         width: 1.0,
// //                       ),
// //                       bottom: BorderSide(
// //                         color: Colors.grey,
// //                         width: 1.0,
// //                       ),
// //                     ),
// //                   ),
// //                   child: DropdownWidget(
// //                     dropdownwidth: screenWidth * 0.25,
// //                     pickupDropdownWidth:
// //                         screenWidth * 0.10, // Lebar dropdown untuk pickup
// //                     tableDropdownWidth:
// //                         screenWidth * 0.10, // Lebar dropdown untuk table
// //                   ),
// //                 ),
// //                 Container(
// //                   child: Iconbutton(),
// //                 ),
// //               ],
// //             ),
// //             Expanded(
// //               child: Row(
// //                 children: [
// //                   Container(
// //                     width: screenWidth * 0.65,
// //                     alignment: Alignment.topLeft,
// //                     child: OrderCard(
// //                       screenWidth: screenWidth,
// //                       onOrderSelected: (orderId) {
// //                         appState.setCurrentConfirmOrderId(orderId);
// //                         //appState.printConfirmedOrders();
// //                       },
// //                       orderan: appState.confirmedOrders,
// //                       currentOrderId: appState.currentConfirmOrderId, // Pass selected order ID
// //                     ),
// //                   ),
// //                   Container(
// //                     width: screenWidth * 0.35,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                     ),
// //                     child: OrderList(
// //                       listorder: appState.confirmedOrders,
// //                       screenWidth: screenWidth,
// //                       appState: appState,
// //                       onAllChecked: (bool isChecked) {
// //                         setState(() {
// //                           allItemsChecked = isChecked;
// //                         });
// //                       },
// //                       currentOrderId: appState.currentConfirmOrderId,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Container(
// //               height: 50,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Container(
// //                     width: screenWidth * 0.65,
// //                     child: Footer(screenWidth: screenWidth),
// //                   ),
// //                   CustomButton(
// //                     screenWidth: MediaQuery.of(context).size.width,
// //                     buttonText: 'Confirm', // Text for the confirm page
// //                     onPressed: () {
// //                       if (appState.currentConfirmOrderId.isNotEmpty) {
// //                         appState.confirmOrderStatus(appState.currentConfirmOrderId);
// //                         print("Order ${appState.currentConfirmOrderId} confirmed");
// //                       }
              
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
