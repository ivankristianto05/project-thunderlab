import 'package:flutter/material.dart';
import 'package:kontena_pos/core/functions/order_new.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';

class BottomNavigationOrder extends StatelessWidget {
  // final double contentHeight;
  VoidCallback? onTapMenu;
  VoidCallback? onTapOrderToServed;
  VoidCallback? onTapOrderToConfirm;
  VoidCallback? onTapAction;
  String? isSelected;

  OrderCart cart = OrderCart();

  BottomNavigationOrder({
    super.key,
    // required this.contentHeight,
    this.onTapMenu,
    this.onTapOrderToServed,
    this.onTapOrderToConfirm,
    this.onTapAction,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    dynamic temp = cart.recapCart();
    double totalPrice = temp['totalPrice'] * 1.0;
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: onTapMenu,
            child: Container(
              height: MediaQuery.sizeOf(context).width * 0.07,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                // border: Border.all(
                //   // right: BorderSide(
                //   color: theme.colorScheme.primary,
                //   width: 2.0,
                //   // ),
                //   // bottom: BorderSide(
                //   //   color: theme.colorScheme.surface,
                //   //   width: 1.0,
                //   // ),
                // ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: isSelected == 'order'
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTapOrderToConfirm,
            child: Container(
              height: MediaQuery.sizeOf(context).width * 0.07,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                // border: Border.all(
                //   // right: BorderSide(
                //   color: theme.colorScheme.primary,
                //   width: 2.0,
                //   // ),
                //   // bottom: BorderSide(
                //   //   color: theme.colorScheme.surface,
                //   //   width: 1.0,
                //   // ),
                // ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm',
                    style: TextStyle(
                      color: isSelected == 'confirm'
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onTapOrderToServed,
            child: Container(
              height: MediaQuery.sizeOf(context).width * 0.07,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                // border: Border.all(
                //   // right: BorderSide(
                //   color: theme.colorScheme.primary,
                //   width: 2.0,
                //   // ),
                //   // bottom: BorderSide(
                //   //   color: theme.colorScheme.surface,
                //   //   width: 1.0,
                //   // ),
                // ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Served',
                    style: TextStyle(
                      color: isSelected == 'served'
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.25,
          height: MediaQuery.sizeOf(context).width * 0.07,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTapAction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cart.items.isNotEmpty
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order',
                                style: cart.items.isNotEmpty
                                    ? TextStyle(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : theme.textTheme.labelLarge,
                              ),
                              Text(
                                '${cart.items.length} item',
                                style: cart.items.isNotEmpty
                                    ? TextStyle(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                      )
                                    : theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                          if (isSelected != 'served')
                            Text(
                              numberFormat(
                                'idr',
                                totalPrice,
                              ),
                              style: cart.items.isNotEmpty
                                  ? TextStyle(
                                      color: theme.colorScheme.primaryContainer,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : theme.textTheme.labelLarge,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
