// import 'package:flutter/material.dart';
// import 'package:kontena_pos/constants.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/confirm_detail.dart';
// import 'package:kontena_pos/features/orders/Screen/popup/confirm_menu.dart';

// class ConfirmInput extends StatefulWidget {
//   @override
//   _ConfirmInputState createState() => _ConfirmInputState();
// }

// class _ConfirmInputState extends State<ConfirmInput> {
//   Map<String, dynamic>? selectedMenu; // Store the selected menu here
//   int _currentIndex = 0; // Track the current page index
//   final PageController _pageController = PageController(); // For page switching

//   void _onMenuSelected(Map<String, dynamic> menu) {
//     setState(() {
//       selectedMenu = menu; // Update selected menu when chosen
//       _currentIndex = 1; // Switch to detail page when a menu is selected
//       _pageController.animateToPage(1,
//           duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(
//         horizontal: screenWidth * 0.05,
//         vertical: screenHeight * 0.05,
//       ),
//       backgroundColor: itembackgroundcolor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         width: screenWidth * 0.9,
//         height: screenHeight * 0.9,
//         child: Column(
//           children: [
//             // AppBar with navigation buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         right: BorderSide(
//                           color: Colors.grey.shade300,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: MaterialButton(
//                       onPressed: () {
//                         setState(() {
//                           _currentIndex = 0;
//                           _pageController.animateToPage(0,
//                               duration: Duration(milliseconds: 500),
//                               curve: Curves.linearToEaseOut);
//                         });
//                       },
//                       height: screenHeight * 0.1,
//                       color: _currentIndex == 0 ? buttonselectedcolor : buttoncolor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                         ),
//                       ),
//                       child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: MaterialButton(
//                     onPressed: () {
//                       if (selectedMenu != null) {
//                         setState(() {
//                           _currentIndex = 1;
//                           _pageController.animateToPage(1,
//                               duration: Duration(milliseconds: 500),
//                               curve: Curves.linearToEaseOut);
//                         });
//                       }
//                     },
//                     height: screenHeight * 0.1,
//                     color: _currentIndex == 1 ? buttonselectedcolor : buttoncolor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: Text('Detail', style: TextStyle(color: Colors.white, fontSize: 20)),
//                   ),
//                 ),
//               ],
//             ),
//             // PageView to switch between Menu and Detail pages
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 children: [
//                   ConfirmInputMenu(onMenuSelected: _onMenuSelected), // Menu page
//                   if (selectedMenu != null)
//                     ConfirmInputDetail(
//                       name: selectedMenu!['nama_menu'], // Pass selected menu details
//                       price: selectedMenu!['harga'],
//                       idMenu: selectedMenu!['id_menu'],
//                       type: selectedMenu!['type'],
//                     ), // Detail page
//                 ],
//               ),
//             ),
//             // Cancel and Save buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     height: screenHeight * 0.08,
//                     color: Colors.grey,
//                     child: Text('Batal', style: TextStyle(color: Colors.white)),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
                      
//                       Navigator.of(context).pop();
//                     },
//                     height: screenHeight * 0.08,
//                     color: Colors.blue,
//                     child: Text('Simpan', style: TextStyle(color: Colors.white)),
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
