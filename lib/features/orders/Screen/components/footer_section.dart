// import 'package:flutter/material.dart';
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/routes/app_routes.dart';

// // class Footer extends StatelessWidget {
// //   const Footer({
// //     super.key,
// //     required this.screenWidth,
// //   });

// //   final double screenWidth;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: _buildFooterButton(
//             text: 'Menu',
//             onPressed: () {
//               // Handle Order button press
//               Navigator.pushNamed(context, AppRoutes.orderScreen);
//             },
//           ),
//         ),
//         Expanded(
//           child: _buildFooterButton(
//             text: 'Confirm',
//             onPressed: () {
//               // Handle Confirm button press
//               //Navigator.pushNamed(context, AppRoutes.confirmScreen);
//             },
//           ),
//         ),
//         Expanded(
//           child: _buildFooterButton(
//             text: 'Served',
//             onPressed: () {
//               // Handle Served button press
//               //Navigator.pushNamed(context, AppRoutes.servescreen);
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: <Widget>[
// //         Expanded(
// //           child: _buildFooterButton(
// //             text: 'Menu',
// //             onPressed: () {
// //               // Handle Order button press
// //               Navigator.pushNamed(context, AppRoutes.orderScreen);
// //             },
// //           ),
// //         ),
// //         Expanded(
// //           child: _buildFooterButton(
// //             text: 'Confirm',
// //             onPressed: () {
// //               // Handle Confirm button press
// //               Navigator.pushNamed(context, AppRoutes.confirmScreen);
// //             },
// //           ),
// //         ),
// //         Expanded(
// //           child: _buildFooterButton(
// //             text: 'Served',
// //             onPressed: () {
// //               // Handle Served button press
// //               Navigator.pushNamed(context, AppRoutes.servescreen);

// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildFooterButton(
// //       {required String text, required VoidCallback onPressed}) {
// //     return Container(
// //       height: 50,
// //       width: screenWidth * 0.35,
// //       decoration: BoxDecoration(
// //         border: Border(
// //           right: BorderSide(color: Colors.white, width: 1.0),
// //         ),
// //       ),
// //       alignment: Alignment.center,
// //       child: MaterialButton(
// //         color: buttoncolor,
// //         textColor: Colors.white,
// //         onPressed: onPressed,
// //         child: Center(
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
