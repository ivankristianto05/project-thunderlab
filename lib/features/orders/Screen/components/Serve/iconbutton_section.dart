// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:provider/provider.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/confirm_input.dart';

// class ServeIconButton extends StatefulWidget {
//   const ServeIconButton({super.key});

//   @override
//   _ServeIconButtonState createState() => _ServeIconButtonState();
// }

// class _ServeIconButtonState extends State<ServeIconButton> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     // Ambil AppState dari Provider
//     final appState = Provider.of<AppState>(context);

//     return Container(
//       child: Row(
//         children: [
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
//                 final currentConfirmOrderId= appState.currentConfirmOrderId;
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
