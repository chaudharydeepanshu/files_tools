// //uncommented as not using a bottom app bar for now. If  use in future then add salomon_bottom_bar in pubspec.yaml and uncomment this and bottom appbar in main scaffold
// import 'package:flutter/material.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
//
// class ReusableBottomAppBar extends StatefulWidget {
//   final int currentIndex = 0;
//   final ValueChanged<int>? onCurrentIndex;
//
//   const ReusableBottomAppBar({Key? key, this.onCurrentIndex}) : super(key: key);
//
//   @override
//   _ReusableBottomAppBarState createState() => _ReusableBottomAppBarState();
// }
//
// class _ReusableBottomAppBarState extends State<ReusableBottomAppBar> {
//   int? _currentIndex;
//
//   void initState() {
//     super.initState();
//     _currentIndex = widget.currentIndex;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(_currentIndex);
//     return Container(
//       color: Colors.white,
//       child: SalomonBottomBar(
//         currentIndex: _currentIndex!,
//         onTap: (i) {
//           setState(() => _currentIndex = i);
//           widget.onCurrentIndex?.call(i);
//         },
//         items: [
//           /// Home
//           SalomonBottomBarItem(
//             icon: Icon(Icons.home_repair_service),
//             title: Text("Tools"),
//             selectedColor: Colors.purple,
//           ),
//
//           /// Tools
//           SalomonBottomBarItem(
//             icon: Icon(Icons.history),
//             title: Text("Recent Docs"),
//             selectedColor: Colors.pink,
//           ),
//
//           /// Scan
//           SalomonBottomBarItem(
//             icon: Icon(Icons.scanner_outlined),
//             title: Text("Scan"),
//             selectedColor: Colors.orange,
//           ),
//
//           /// Create
//           SalomonBottomBarItem(
//             icon: Icon(Icons.create_new_folder_outlined),
//             title: Text("Create"),
//             selectedColor: Colors.teal,
//           ),
//         ],
//       ),
//     );
//   }
// }
