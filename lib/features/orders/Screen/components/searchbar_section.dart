import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Searchbar extends StatefulWidget {
  final double screenWidth;
  final void Function(String) onSearchChanged;

  const Searchbar({
    Key? key,
    required this.screenWidth,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text); // Notify parent on search change
      setState(() {}); // Update the UI when the text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth, // Set the width using screenWidth parameter
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Stack(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Menu',
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Visibility(
              visible: _searchController.text.isNotEmpty,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.circleXmark),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}