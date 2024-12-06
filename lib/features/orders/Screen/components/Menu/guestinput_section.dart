// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:kontena_pos/app_state.dart';
// import 'package:provider/provider.dart';

// class GuestInputWithButton extends StatefulWidget {
//   final double screenWidth;
//   final TextEditingController guestNameController;
//   final double smallButtonWidth;
//   final Function(String) onNameSubmitted; // Add this callback

//   const GuestInputWithButton({
//     Key? key,
//     required this.screenWidth,
//     required this.guestNameController,
//     required this.smallButtonWidth,
//     required this.onNameSubmitted, // Initialize the callback
//   }) : super(key: key);

//   @override
//   _GuestInputWithButtonState createState() => _GuestInputWithButtonState();
// }

// class _GuestInputWithButtonState extends State<GuestInputWithButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.screenWidth * 0.35,
//       height: 55,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 55,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   right: BorderSide(
//                     color: Colors.grey,
//                     width: 1.0,
//                   ),
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   TextField(
//                     controller: widget.guestNameController,
//                     decoration: InputDecoration(
//                       hintText: 'Input Guest Name',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: InputBorder.none,
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 18, horizontal: 8),
//                     ),
//                     onChanged: (text) {
//                       final appState =
//                           Provider.of<AppState>(context, listen: false);
//                       appState.setNamaPemesan(text);
//                     },
//                   ),
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     bottom: 0,
//                     child: Visibility(
//                       visible: widget.guestNameController.text.isNotEmpty,
//                       child: IconButton(
//                         icon: FaIcon(FontAwesomeIcons.circleXmark),
//                         onPressed: () {
//                           widget.guestNameController.clear();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }