import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class SelectItemGroup extends StatefulWidget {
  SelectItemGroup({super.key, required this.onSelected, this.selected});

  final void Function(List<dynamic>) onSelected;
  final List<dynamic>? selected;

  @override
  _SelectItemGroupState createState() => _SelectItemGroupState();
}

class _SelectItemGroupState extends State<SelectItemGroup> {
  List<dynamic> selectedOptions = [];
  List<dynamic> itemGroupDisplay = [];
  List<dynamic> itemGroup = [];

  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    setState((){
      itemGroup = AppState().configPosProfile['item_groups'];
      itemGroupDisplay = itemGroup.map((e) => e["item_group"]).toList();
      
      if (widget.selected != null) {
        setState((){
          selectedOptions = widget.selected!;
          selectAll = widget.selected?.length == itemGroupDisplay.length;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Text(
                          'Choose item group',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: Icon(
                                Icons.close_rounded,
                                color: theme.colorScheme.secondary,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: theme.colorScheme.surface,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 8.0),
                          child: CheckboxListTile(
                            title: Text("Select All"),
                            value: selectAll,
                            onChanged: (isChecked) {
                              setState(() {
                                selectAll = isChecked ?? false;
                                selectedOptions = selectAll ? List.from(itemGroupDisplay) : [];
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 8.0),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: itemGroupDisplay.length,
                            itemBuilder: (context, index) {
                              final item = itemGroupDisplay[index];
                              return CheckboxListTile(
                                value: selectedOptions.contains(item),
                                title: Text(item),
                                onChanged: (isChecked) {
                                  print('cetnang, $isChecked');
                                  // print('cetnang, ${tempSelectedOptions.contains(option)}');
                                  setState(() {
                                    if (isChecked ?? false) {
                                      print(1);
                                      selectedOptions.add(item);
                                    } else {
                                      print(2);
                                      selectedOptions.remove(item);
                                    }
                                    selectAll = selectedOptions.length == itemGroupDisplay.length;
                                  });
                                },
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: theme.colorScheme.surface,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                // AppState().tableNumber = TableNumber;

                              });
                              widget.onSelected(selectedOptions);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    4.0, 4.0, 4.0, 4.0),
                                child: Text(
                                  'Confirm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
    );
  }
}