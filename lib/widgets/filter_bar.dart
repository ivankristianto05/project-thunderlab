import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/app_export.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';

class FilterBar extends StatefulWidget {
  final void Function(String type) onFilterSelected;
  final List<dynamic>? filterData;
  final String? fieldValue;

  FilterBar({
    Key? key,
    required this.onFilterSelected,
    this.filterData,
    this.fieldValue,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String _selectedFilter = 'All'; // Default selected filter
  List<dynamic> filterDisplay = [];
  String fieldName = 'name';

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.filterData != null) {
        filterDisplay = widget.filterData!;
      } else {
        filterDisplay = AppState().dataItemGroup;
      }

      if (widget.fieldValue != null) {
        fieldName = widget.fieldValue!;
      } else {
        fieldName = 'name';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleFilterButtonPressed(String type) {
    setState(() {
      _selectedFilter = type;
    });
    widget.onFilterSelected(type);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate button width based on screen width
    // double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = (MediaQuery.of(context).size.width * 0.45 - 145) /
        4; // 65% of screen width divided among 4 buttons, minus padding

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildFilterButton('All', '', buttonWidth),
            const SizedBox(width: 8),
            Builder(
              builder: (context) {
                return Row(
                  children: List.generate(
                    filterDisplay.length,
                    (index) {
                      final filterItem = filterDisplay[index];
                      String captionItem = filterItem.containsKey('amount')
                          ? numberFormat('idr', filterItem['amount'])
                          : '';
                      return Row(
                        children: [
                          _buildFilterButton(
                              filterItem[fieldName], captionItem, buttonWidth),
                          const SizedBox(width: 8),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            // _buildFilterButton('food', buttonWidth),
            // SizedBox(width: 8),
            // _buildFilterButton('beverage', buttonWidth),
            // SizedBox(width: 8),
            // _buildFilterButton('breakfast', buttonWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String type, String? caption, double width) {
    bool isSelected = _selectedFilter == type;
    return SizedBox(
      height: 48,
      width: 180.0,
      child: CustomElevatedButton(
        text: type.toUpperCase(),
        buttonTextStyle: isSelected
            ? TextStyle(color: theme.colorScheme.primaryContainer)
            : TextStyle(color: theme.colorScheme.secondary),
        buttonStyle: isSelected
            ? CustomButtonStyles.primary
            : CustomButtonStyles.outlineSecondary,
        onPressed: () => _handleFilterButtonPressed(type),
      ),
    );
  }
}
