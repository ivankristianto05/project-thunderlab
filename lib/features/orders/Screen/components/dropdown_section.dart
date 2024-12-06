// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:kontena_pos/core/functions/cart.dart';

// class DropdownWidget extends StatefulWidget {
//   final double dropdownwidth;
//   final double pickupDropdownWidth;
//   final double tableDropdownWidth;

//   const DropdownWidget({
//     Key? key,
//     required this.dropdownwidth, // Parameter untuk lebar dropdown
//     required this.pickupDropdownWidth, // Parameter untuk lebar pickup dropdown
//     required this.tableDropdownWidth,  // Parameter untuk lebar table dropdown
//   }) : super(key: key);

//   @override
//   _DropdownWidgetState createState() => _DropdownWidgetState();
// }

// class _DropdownWidgetState extends State<DropdownWidget> {
//   String? pickupType;
//   String? table;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final appState = Provider.of<AppState>(context, listen: true);

//     // Update the table value based on the current selected table from AppState
//     setState(() {
//       final fetchedTable = appState.getTableForCurrentOrder();
//       // Jika table adalah '', set nilai table menjadi null
//       table = fetchedTable.isNotEmpty ? fetchedTable : null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     // Access AppState and Cart
//     final appState = Provider.of<AppState>(context);
//     final cart = Cart(appState, onCartChanged: () => setState(() {}));

//     // Define table options
//     final List<String> tableOptions = <String>[
//       '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
//     ];

//     // Check if order ID is selected
//     final hasOrderId = appState.currentConfirmOrderId.isNotEmpty;

//     return Container(
//       width: widget.dropdownwidth, // Gunakan parameter lebar yang diterima
//       height: 50,
//       alignment: Alignment.topRight,
//       child: Row(
//         children: [
//           // Dropdown untuk Pickup Type
//           Expanded(
//             child: Container(
//               width: widget.pickupDropdownWidth, // Gunakan parameter lebar yang diterima
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   right: BorderSide(
//                     color: Colors.grey,
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//               height: 50,
//               child: DropdownButtonHideUnderline(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     hint: const Text("Select an Option"),
//                     value: pickupType,
//                     items: <String>['Dine in', 'Take away', 'Gojek'].map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Center(
//                           child: Text(
//                             value,
//                             style: const TextStyle(fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         pickupType = newValue;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Dropdown untuk Table
//           Container(
//             width: widget.tableDropdownWidth, // Gunakan parameter lebar yang diterima
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 right: BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//             ),
//             height: 50,
//             child: DropdownButtonHideUnderline(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   hint: const Text("Table"),
//                   value: table, // Use the value stored in the state
//                   items: hasOrderId
//                       ? tableOptions.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Center(
//                               child: Text(
//                                 'Table $value',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList()
//                       : [], // Empty list when no order ID is selected
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       table = newValue;
//                     });
//                     if (newValue != null) {
//                       appState.setSelectedTable(newValue); // Save selected table to AppState
//                     }
//                   },
//                   selectedItemBuilder: (BuildContext context) {
//                     return hasOrderId
//                         ? tableOptions.map((String value) {
//                             return Center(
//                               child: Text(
//                                 'Table $value',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                             );
//                           }).toList()
//                         : []; // Empty list when no order ID is selected
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
