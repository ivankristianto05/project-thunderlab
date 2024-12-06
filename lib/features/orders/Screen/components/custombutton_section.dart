// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // For accessing AppState
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/app_state.dart'; // Import the AppState

// class CustomButton extends StatefulWidget {
//   final double screenWidth;
//   final String buttonText; // New parameter for button text
//   final VoidCallback? onPressed; // New parameter for button action

//   CustomButton({
//     super.key,
//     required this.screenWidth,
//     required this.buttonText, // Require the buttonText
//     required this.onPressed, // Require the onPressed function
//   });

//   @override
//   _CustomButtonState createState() => _CustomButtonState();
// }

// class _CustomButtonState extends State<CustomButton> {
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     final orderId = appState.currentConfirmOrderId;

//     // Enable button only if the current order ID is fully checked
//     bool isEnabled = appState.isOrderFullyChecked(orderId);
//     var buttonColor = isEnabled ? buttoncolor : Colors.grey;

//     return Container(
//       height: 50,
//       width: widget.screenWidth * 0.35,
//       child: MaterialButton(
//         color: buttonColor,
//         textColor: Colors.white,
//         onPressed: isEnabled ? widget.onPressed : null, // Use the passed function
//         child: Center(
//           child: Text(
//             widget.buttonText, // Use the passed text
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }
