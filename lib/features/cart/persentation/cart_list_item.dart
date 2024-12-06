import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/functions/cart.dart';
import 'package:kontena_pos/core/functions/invoice.dart';
import 'package:kontena_pos/core/functions/order_new.dart';
import 'package:kontena_pos/core/theme/custom_text_style.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/models/cartitem.dart';
import 'package:kontena_pos/widgets/list_cart.dart';

class CardListItem extends StatefulWidget {
  // final List<CartItem> cartData;

  CardListItem({
    Key? key,
    // required this.cartData,
  }) : super(key: key);

  @override
  _CardListItem createState() => _CardListItem();
}

class _CardListItem extends State<CardListItem> {
  // Map<String, dynamic> item;
  int totalAddon = 0;
  int totalAddonCheckout = 0;
  OrderCart orderCart = OrderCart();
  InvoiceCart invoiceCart = InvoiceCart();
  late List<OrderCartItem> cartData;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    cartData = orderCart.getAllItemCart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          primary: true,
          child: Container(
              height: 700,
              child: Builder(
                builder: (context) {
                  final itemCart = orderCart.getAllItemCart();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final itemData = cartData[index];

                      String addon2 = '';
                      String catatan = '';
                      String preference = '';
                      totalAddon = 0;
                      List<dynamic> addons = [];

                      catatan = itemData.notes.toString();
                      print('addon, ${itemData.addon}');
                      // print('pref, ${itemData.pref}');

                      if (itemData.addon != null) {}

                      // if (itemData.addon!.isNotEmpty) {
                      //   itemData.addon!.forEach((value) {
                      //     addons.add({
                      //       'name': value['nama_menu'],
                      //       'qty': value['qty'],
                      //       'price': numberFormat('idr', value['harga']),
                      //     });
                      //     // String itemName = value["itemName"] as String;
                      //     // String price = value["price"];

                      //     // addon2 +=
                      //     //     "$itemName - (${numberFormat('idr', double.parse(price))})\n";
                      //     totalAddon +=
                      //         (double.parse(value['harga'].toString()).toInt() *
                      //             double.parse(value['qty'].toString()).toInt());
                      //   });
                      // }

                      // if (itemData.preference != null) {
                      //   int i = 1;
                      //   itemData.preference?.forEach((element) {
                      //     preference +=
                      //         "${element['type']}: ${element['name']}";
                      //     if (i < itemData.preference!.length) {
                      //       preference += ", ";
                      //     }
                      //     i++;
                      //   });
                      // }

                      return Container(
                        child: ListCart(
                          title: "${itemData.name} (${itemData.qty})",
                          subtitle: itemData.name,
                          // addon: addon2,
                          // addons: addons,
                          qty: itemData.qty.toString(),
                          catatan: preference,
                          titleStyle: CustomTextStyles.labelLargeBlack,
                          price: itemData.price.toString(),
                          total: numberFormat('idr',
                              itemData.qty * (itemData.price + totalAddon)),
                          priceStyle: CustomTextStyles.labelLargeBlack,
                          labelStyle: CustomTextStyles.bodySmallBluegray300,
                          editLabelStyle: CustomTextStyles.bodySmallOrange600,
                          padding: EdgeInsets.all(16),
                          note: itemData.notes ?? '',
                          lineColor: appTheme.gray200,
                          secondaryStyle: CustomTextStyles.bodySmallGray,
                          // onTap: () => onTapItem(context, index, itemData),
                        ),
                      );
                    },
                  );
                },
              )

              // ],
              ),
        ),
      ],
    );
  }

  void onTapItem(BuildContext context, int index, CartItem itemData) {}
}
