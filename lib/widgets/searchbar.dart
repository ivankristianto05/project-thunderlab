import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class Searchbar extends StatefulWidget {
  final void Function(String)? onChanged;
  final Function(String)? onCompleted;
  // String? selected;

  Searchbar({
    super.key,
    this.onChanged,
    this.onCompleted,
    // this.selected,
  });

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  TextEditingController enterSearch = TextEditingController();
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    enterSearch.addListener(() {
      setState(() {
        _showClearIcon = enterSearch.text.isNotEmpty;
      });
    });
    // if (widget.selected != '') {
    //   enterSearch.text = widget.selected!;
    // }
  }

  @override
  void dispose() {
    enterSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.surface,
            width: 1.0,
          ),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Menu',
          hintStyle: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: 14.0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12.0),
          suffixIcon: _showClearIcon
              ? InkWell(
                  onTap: () {
                    enterSearch.clear(); // Clear the text in the controller
                    widget.onChanged
                        ?.call(''); // Notify onChanged with empty string
                    setState(() {
                      _showClearIcon = false; // Hide the clear icon
                    });
                  },
                  child: Icon(
                    Icons.clear,
                    color: theme.colorScheme.outline,
                    size: 24.0,
                  ),
                )
              : null,
        ),
        onChanged: (value) {
          EasyDebounce.debounce(
            'enterSearch',
            const Duration(milliseconds: 300),
            () => widget.onChanged?.call(value),
          );
          // setState(() {
          //   _showClearIcon = true; // Hide the clear icon
          // });
        },
        // onEditingComplete: onCompletedChange,
      ),
    );
  }

  onCompletedChange() {
    widget.onCompleted?.call(enterSearch.text);
  }
}
