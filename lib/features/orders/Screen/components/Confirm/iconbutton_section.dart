// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:provider/provider.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/confirm_input.dart';

// class Iconbutton extends StatefulWidget {
//   const Iconbutton({super.key});

//   @override
//   _IconbuttonState createState() => _IconbuttonState();
// }

// class _IconbuttonState extends State<Iconbutton> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     // Ambil AppState dari Provider
//     final appState = Provider.of<AppState>(context);

//     return Container(
//       child: Row(
//         children: [
//           // PLUS icon button
//           Container(
//             width: screenWidth * 0.05,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 right: BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//             ),
//             child: MaterialButton(
//               height: 50,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 if (appState.currentConfirmOrderId != null &&
//                     appState.currentConfirmOrderId.isNotEmpty) {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return ConfirmInput();
//                     },
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Silakan pilih order terlebih dahulu!'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: FaIcon(FontAwesomeIcons.plus, color: Colors.grey),
//             ),
//           ),
//           // Change icon button
//           Container(
//             width: screenWidth * 0.05,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 right: BorderSide(
//                   color: Colors.grey,
//                   width: 1.0,
//                 ),
//               ),
//             ),
//             child: MaterialButton(
//               height: 50,
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 final currentConfirmOrderId = appState.currentConfirmOrderId;
//                 if (currentConfirmOrderId.isNotEmpty) {
//                   appState.checkAllItemsInOrder(
//                       currentConfirmOrderId); // Panggil fungsi check all
//                 } else {
//                   print('Tidak ada order yang dipilih.');
//                 }
//               },
//               child:
//                   FaIcon(FontAwesomeIcons.check, color: Colors.cyan, size: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
