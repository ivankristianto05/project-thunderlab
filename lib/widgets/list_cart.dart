import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:styled_divider/styled_divider.dart';

class ListCart extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final String qty;
  final String addon;
  final String note;
  final TextStyle
      secondaryStyle; // Merged parameter for noteStyle and addonStyle
  final String editLabel;
  final TextStyle editLabelStyle;
  final String price;
  final String total;
  final List<dynamic>? addons;
  final TextStyle priceStyle;
  final EdgeInsets padding;
  final Color lineColor;
  final TextStyle labelStyle;
  final VoidCallback? onEdit; // Added onTap parameter
  final VoidCallback? onDelete; // Added onTap parameter
  final String catatan;
  final bool isEdit;
  final int docstatus;
  // final String catatan;

  ListCart({
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.title = "Hot Chocolate",
    this.titleStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    this.subtitle = 'Hot Chocolate Large',
    this.qty = '1x',
    this.addon = "",
    this.note = "Less Ice, Less Sugar",
    this.secondaryStyle =
        const TextStyle(fontSize: 14, color: Colors.grey), // Merged parameter
    this.editLabel = "",
    this.editLabelStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
    this.price = "IDR 120.000",
    this.priceStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    this.total = "IDR 120.000",
    this.padding = const EdgeInsets.all(8.0),
    this.lineColor = Colors.black, // Default line color is black
    this.labelStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.addons,
    this.onEdit,
    this.onDelete,
    this.catatan = "",
    this.isEdit = true,
    this.docstatus = 0,
  });

  @override
  Widget build(BuildContext context) {
    print('dco stas, $docstatus');
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                StyledDivider(
                  height: 15.0,
                  thickness: 2.0,
                  color: theme.colorScheme.outline,
                  lineStyle: DividerLineStyle.dotted,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${qty}x ${numberFormat('idr', double.parse(price))}"),
                    Text(
                      total,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                if ((addons != null) && (addons?.length != 0))
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Addon:',
                          style: theme.textTheme.labelSmall,
                        ),
                        Builder(builder: (context) {
                          final addonList = addons?.toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: addonList?.length,
                            itemBuilder: (context, index) {
                              final addonItem = addonList?[index];
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('+ ${addonItem['item_name']}'),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10.0, 0.0, 0.0, 0.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              '${addonItem['qty']}x ${numberFormat('idr', addonItem['rate'])}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                if (catatan != '')
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preference:',
                          style: theme.textTheme.labelSmall,
                        ),
                        Text(
                          catatan,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                if (note != '')
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes:',
                          style: theme.textTheme.labelSmall,
                        ),
                        Text(note),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // if (isEdit)
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if ((docstatus == 0) && (isEdit == true))
              Padding(
                padding: EdgeInsetsDirectional
                    .fromSTEB(
                        8.0,
                        0.0,
                        0.0,
                        0.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize
                          .max,
                  children: [
                    InkWell(
                      onTap: onEdit,
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if ((docstatus == 0) && (isEdit == true))
              Padding(
                padding: EdgeInsetsDirectional
                    .fromSTEB(
                        0.0,
                        0.0,
                        8.0,
                        0.0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize
                          .max,
                  children: [
                    InkWell(
                      onTap: onDelete,
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 5.0,
            thickness: 0.5,
            color: theme.colorScheme.outline,
          ),
        ],
      // ),
    );
  }
}
