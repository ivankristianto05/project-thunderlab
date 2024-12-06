import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/functions/invoice.dart';
import 'package:kontena_pos/core/functions/payment_prediction.dart';
import 'package:kontena_pos/core/utils/print.dart';
import 'package:kontena_pos/core/theme/custom_text_style.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/data/mode_payment.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';
import 'package:kontena_pos/widgets/custom_outlined_button.dart';
import 'package:kontena_pos/widgets/list_cart.dart';
import 'package:kontena_pos/widgets/numpad.dart';

import 'package:http/http.dart' as http;
import 'package:kontena_pos/core/utils/alert.dart' as alert;

import 'package:kontena_pos/core/api/frappe_thunder_pos/create_pos_invoice.dart'
    as frappeFetchDataInvoice;

import 'package:kontena_pos/core/api/send_printer.dart' as sendToPrinter;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic paymentService = {
    'Dine in',
    'Take Away',
    'Gojek',
    'Grab',
    'Shopee',
  };
  List<dynamic> discountDisplay = [
    {'value': 'additional_discount_percentage', 'display': 'Percentase (%)'},
    {'value': 'discount_amount', 'display': 'Nominal (IDR)'},
  ];
  double payment = 0.0;
  double bill = 0.0;
  int discount = 0;
  int grandTotal = 0;

  String paymentMethod = 'Cash';
  String selectedDiscount = 'additional_discount_percentage';

  bool paymentStatus = false;
  bool isLoading = false;

  late List<dynamic> cardListMethod;
  late List<dynamic> digitalListMethod;
  List<dynamic> listPaymentMethod = [];

  InvoiceCart cart = InvoiceCart();
  late List<InvoiceCartItem> cartData;
  dynamic invoice;

  TextEditingController discountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      dynamic recapCart = cart.recapCart();
      bill = recapCart['totalPrice'] * 1.0;
      grandTotal = recapCart['totalPrice'];
      cardListMethod = card;
      digitalListMethod = digital;
      cartData = cart.getAllItemCart();
      listPaymentMethod = AppState().configPosProfile['payments'];
    });
    discountController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 45.0,
              decoration: BoxDecoration(color: theme.colorScheme.surface),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!paymentStatus)
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // setState(() {
                          //   FFAppState().ActivePage = 'Menu';
                          // });
                          // context.pop();
                          onTapClose(context);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: theme.colorScheme.secondary,
                          size: 24.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1,
              color: theme.colorScheme.outline,
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      // height: 600.0,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        // child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 6.0, 0.0, 0.0),
                                  child: Text(
                                    'Discount',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 6.0, 0.0, 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 140.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: theme.colorScheme.outline,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontSize: 14.0,
                                              ),
                                              hint: const Text(
                                                  "Select an Option"),
                                              value: selectedDiscount,
                                              items: discountDisplay
                                                  .map((dynamic value) {
                                                return DropdownMenuItem<String>(
                                                  value: value['value'],
                                                  child: Text(
                                                    value['display'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  // selectedTipePrinter =
                                                  //     newValue!;
                                                  selectedDiscount = newValue!;
                                                  // discount = 0;
                                                  discountController.text = '0';
                                                  grandTotal = 0;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 140.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: theme.colorScheme.outline,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: discountController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter nominal discount',
                                            hintStyle: TextStyle(
                                              color: theme.colorScheme
                                                  .onPrimaryContainer,
                                              fontSize: 14.0,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                              0.0,
                                              16.0,
                                              0.0,
                                              16.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.right,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9]'))
                                          ],
                                          onChanged: (value) {
                                            EasyDebounce.debounce(
                                              'enterSearch',
                                              const Duration(milliseconds: 300),
                                              () {
                                                setState(() {
                                                  discount = int.parse(
                                                      discountController.text);
                                                });
                                                onChangeDiscount();
                                              },
                                            );
                                          },
                                          onEditingComplete: () {
                                            setState(() {
                                              discount = int.parse(
                                                  discountController.text);
                                            });
                                            onChangeDiscount();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 5.0,
                                  thickness: 0.5,
                                  color: theme.colorScheme.outline,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              color: appTheme.gray500,
                                              fontSize: 16.0,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            numberFormat(
                                              'idr',
                                              bill,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Discount",
                                            style: TextStyle(
                                              color: appTheme.gray500,
                                              fontSize: 16.0,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            selectedDiscount ==
                                                    'additional_discount_percentage'
                                                ? '${discount.toString()}%'
                                                : numberFormat(
                                                    'idr',
                                                    discount,
                                                  ),
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Grand Total",
                                            style: TextStyle(
                                              color: appTheme.gray500,
                                              fontSize: 16.0,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            numberFormat(
                                              'idr',
                                              grandTotal,
                                            ),
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 5.0,
                                  thickness: 0.5,
                                  color: theme.colorScheme.outline,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 8.0, 0.0, 8.0),
                                        child: Text(
                                          'Metode Payment',
                                          style: theme.textTheme.titleSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        return AlignedGridView.count(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 1,
                                          crossAxisSpacing: 12,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: listPaymentMethod.length,
                                          itemBuilder: (context, index) {
                                            final methodPayment =
                                                listPaymentMethod[index];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                setState(() {
                                                  paymentMethod = methodPayment[
                                                      'mode_of_payment'];
                                                });
                                                if (methodPayment[
                                                            'mode_of_payment']
                                                        .toString()
                                                        .toLowerCase() !=
                                                    'cash') {
                                                  if (discount > 0) {
                                                    payment = grandTotal * 1.0;
                                                  } else {
                                                    payment = bill;
                                                  }
                                                } else {
                                                  payment = 0;
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 10.0, 0.0, 10.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: paymentMethod
                                                                .toString()
                                                                .toLowerCase() ==
                                                            methodPayment[
                                                                    'mode_of_payment']
                                                                .toString()
                                                                .toLowerCase()
                                                        ? theme
                                                            .colorScheme.primary
                                                        : theme.colorScheme
                                                            .primaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    border: Border.all(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(16.0,
                                                            16.0, 16.0, 16.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          methodPayment[
                                                                  'mode_of_payment']
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: paymentMethod
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    methodPayment[
                                                                            'mode_of_payment']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                ? theme
                                                                    .colorScheme
                                                                    .primaryContainer
                                                                : theme
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                        ),
                                                        if (paymentMethod
                                                                .toString()
                                                                .toLowerCase() ==
                                                            methodPayment[
                                                                    'mode_of_payment']
                                                                .toString()
                                                                .toLowerCase())
                                                          Icon(
                                                            Icons.check,
                                                            color: theme
                                                                .colorScheme
                                                                .primaryContainer,
                                                            size: 14.0,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1.0,
                          ),
                          right: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NumPad(
                            isDisable: paymentStatus,
                            initialValue: payment,
                            onResult: (value) {
                              setState(() {
                                payment = double.parse(value);
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16, 16.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (isLoading)
                                  Container(
                                    width: double.infinity,
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 0.0, 8.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Center(
                                            child: SizedBox(
                                              width: 23,
                                              height: 23,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10.0, 0.0, 8.0, 0.0),
                                            child: Text(
                                              'Loading...',
                                              style: TextStyle(
                                                  color: theme.colorScheme
                                                      .primaryContainer),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if ((isLoading == false) &&
                                    (paymentStatus == false))
                                  CustomOutlinedButton(
                                    height: 48.0,
                                    text: "Pay",
                                    isDisabled: ((discount > 0
                                        ? (payment < grandTotal)
                                        : (payment < bill))),
                                    buttonTextStyle: TextStyle(
                                        color:
                                            theme.colorScheme.primaryContainer),
                                    buttonStyle: ((discount > 0
                                            ? (payment < grandTotal)
                                            : (payment < bill)))
                                        ? CustomButtonStyles.onPrimaryContainer
                                        : CustomButtonStyles.primary,
                                    onPressed: () {
                                      onTapPay(context);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  Container(
                    width: 250,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 10.0, 10.0, 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppState().typeTransaction,
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 5.0,
                                            thickness: 0.5,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      paymentMethod != ''
                                                          ? paymentMethod
                                                          : '-',
                                                      style: theme
                                                          .textTheme.bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50.0,
                                                child: VerticalDivider(
                                                  width: 5.0,
                                                  thickness: 0.5,
                                                  color:
                                                      theme.colorScheme.outline,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (paymentStatus == false)
                                                      Text(
                                                        'Unpaid',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .onError,
                                                        ),
                                                      ),
                                                    if (paymentStatus)
                                                      Text(
                                                        'Paid',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .primary,
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
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Total',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        numberFormat(
                                                            'idr', bill),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Discount',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        selectedDiscount ==
                                                                'additional_discount_percentage'
                                                            ? '${discount.toString()}%'
                                                            : numberFormat(
                                                                'idr',
                                                                discount,
                                                              ),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Grand Total',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        numberFormat(
                                                            'idr', grandTotal),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: theme
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 5.0,
                                            thickness: 0.5,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Pay',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        numberFormat(
                                                            'idr', payment),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Change',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      if ((payment -
                                                              grandTotal) >=
                                                          0)
                                                        Text(
                                                          numberFormat(
                                                            'idr',
                                                            (payment -
                                                                grandTotal),
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: theme.textTheme
                                                              .bodyMedium,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final itemCart = cartData;
                                            int totalAddon = 0;
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: itemCart.length,
                                              itemBuilder:
                                                  (context, itemCartIndex) {
                                                final itemCartItem =
                                                    itemCart[itemCartIndex];
                                                return ListCart(
                                                  title:
                                                      "${itemCartItem.itemName} (${itemCartItem.qty})",
                                                  subtitle:
                                                      itemCartItem.itemName ??
                                                          '-',
                                                  // addon: addon2,
                                                  // addons: addons,
                                                  qty: itemCartItem.qty
                                                      .toString(),
                                                  // catatan: itemCartItem.preference,
                                                  titleStyle: CustomTextStyles
                                                      .labelLargeBlack,
                                                  price: itemCartItem.price
                                                      .toString(),
                                                  total: numberFormat(
                                                      'idr',
                                                      itemCartItem.qty *
                                                          (itemCartItem.price +
                                                              totalAddon)),
                                                  priceStyle: CustomTextStyles
                                                      .labelLargeBlack,
                                                  labelStyle: CustomTextStyles
                                                      .bodySmallBluegray300,
                                                  editLabelStyle: TextStyle(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  note:
                                                      itemCartItem.notes ?? '',
                                                  lineColor: appTheme.gray200,
                                                  secondaryStyle:
                                                      CustomTextStyles
                                                          .bodySmallGray,
                                                  isEdit: false,
                                                  // onTap: () => onTapEditItem(
                                                  //     context,
                                                  //     itemData,
                                                  //     index),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (paymentStatus)
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Divider(
                                  height: 5.0,
                                  thickness: 0.5,
                                  color: theme.colorScheme.outline,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CustomOutlinedButton(
                                        height: 48.0,
                                        text: "Reprint Invoice",
                                        buttonTextStyle: TextStyle(
                                            color: theme.colorScheme.primary),
                                        buttonStyle:
                                            CustomButtonStyles.outlinePrimary,
                                        onPressed: () {
                                          onPrintInvoice(true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CustomOutlinedButton(
                                        height: 48.0,
                                        text: "Reprint Checker",
                                        buttonTextStyle: TextStyle(
                                            color: theme.colorScheme.primary),
                                        buttonStyle:
                                            CustomButtonStyles.outlinePrimary,
                                        onPressed: () {
                                          onPrintChecker(true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CustomElevatedButton(
                                        text: "Done",
                                        buttonTextStyle: TextStyle(
                                            color: theme
                                                .colorScheme.primaryContainer),
                                        buttonStyle:
                                            CustomButtonStyles.primaryButton,
                                        onPressed: () {
                                          onTapDone(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapClose(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.invoiceScreen,
      (route) => false,
    );
  }

  onTapPay(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await onCallPosInvoice();
  }

  onTapDone(BuildContext context) async {
    setState(() {
      AppState.resetInvoiceCart();
      AppState().typeTransaction = 'dine-in';
      AppState().customerSelected = null;
    });
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.invoiceScreen,
      (route) => false,
    );
  }

  onCallPosInvoice() async {
    List<dynamic> tempItem = [];
    List<dynamic> tempPayment = [];

    for (var element in cartData) {
      tempItem.add({
        'item_code': element.name,
        'qty': element.qty,
        'pos_order': element.id.contains(element.itemName) ? null : element.id,
      });
    }

    // print('check config payment, ${AppState().configCompany}');

    for (var methodPay in AppState().configPosProfile['payments']) {
      if (paymentMethod.toLowerCase() ==
          methodPay['mode_of_payment'].toString().toLowerCase()) {
        tempPayment.add({
          'mode_of_payment': methodPay['mode_of_payment'],
          'amount': payment,
          // 'account': methodPay['account']
        });
      }
      // print('check, $methodPay');
    }

    final frappeFetchDataInvoice.CreatePosInvoiceRequest request =
        frappeFetchDataInvoice.CreatePosInvoiceRequest(
      cookie: AppState().cookieData,
      // customer: '0',
      // customerName: 'Guest',
      customer: AppState().customerSelected != null
          ? AppState().customerSelected['name']
          : '0',
      customerName: AppState().customerSelected != null
          ? AppState().customerSelected['customer_name']
          : 'Guest',
      company: AppState().configCompany['name'],
      postingDate: dateTimeFormat('date', null).toString(),
      postingTime: timeFormat('time_full', null),
      outlet: AppState().configPosProfile['name'],
      currency: AppState().configPosProfile['currency'],
      conversionRate: 1,
      sellingPriceList: AppState().configPosProfile['selling_price_list'],
      priceListCurrency: AppState().configPosProfile['currency'],
      plcConversionRate: 1,
      debitTo: AppState().configCompany['default_receivable_account'],
      costCenter: AppState().configCompany['cost_center'],
      items: tempItem,
      baseNetTotal: bill,
      baseGrandTotal: discount > 0 ? grandTotal * 1.0 : bill,
      grandTotal: discount > 0 ? grandTotal * 1.0 : bill,
      payments: tempPayment,
      basePaidAmount: payment,
      paidAmount: payment,
      discountAmount:
          selectedDiscount == 'additional_discount_percentage' ? 0 : discount,
      additionalDiscountPercentage:
          selectedDiscount == 'discount_amount' ? 0 : discount,
    );

    try {
      // print('check request, ${request}');
      final callRespon =
          await frappeFetchDataInvoice.request(requestQuery: request);
      print('call respon, ${callRespon}');
      if (callRespon != null) {
        setState(() {
          paymentStatus = true;
          invoice = callRespon;
          isLoading = false;
        });

        if (AppState()
                .configPrinter['tipeConnection']
                .toString()
                .toLowerCase() ==
            'bluetooth') {
          onPrintInvoiceBluetooth(false);
          onPrintCheckerBluetooth(false);
        } else {
          onPrintInvoice(false);
          onPrintChecker(false);
        }

        if (context.mounted) {
          alert.alertSuccess(
              context, 'SuccesSuccessfully created a transaction');
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error pos invoice, ${error}');
      if (context.mounted) {
        alert.alertError(context, error.toString());
      }
    }
  }

  onPrintInvoice(bool reprint) async {
    dynamic docPrint = await printInvoice(
        reprint ? 'reprint' : null,
        invoice,
        AppState().configPrinter,
        AppState().configCompany,
        AppState().configPosProfile,
        AppState().configUser);

    print('print invoce, $docPrint');

    final sendToPrinter.ToPrint request =
        sendToPrinter.ToPrint(doc: docPrint, ipAddress: '127.0.0.1');
    try {
      final callRespon = await sendToPrinter.request(requestQuery: request);
      // print('call respon, ${callRespon}');
      if (callRespon != null) {
        // setState((){
        //   paymentStatus = true;
        //   invoice = callRespon;
        // });
      }
    } catch (error) {
      // print('error pos invoice, ${error}');
      if (context.mounted) {
        alert.alertError(context, error.toString());
      }
    }
  }

  onPrintChecker(bool reprint) async {
    dynamic docPrint = await printChecker(
      invoice,
      AppState().configPrinter,
      AppState().configApplication,
      reprint ? 'reprint' : null,
    );

    // print('print invoce, $docPrint');

    final sendToPrinter.ToPrint request =
        sendToPrinter.ToPrint(doc: docPrint, ipAddress: '127.0.0.1');
    try {
      final callRespon = await sendToPrinter.request(requestQuery: request);
      print('call respon, ${callRespon}');
      if (callRespon != null) {
        // setState((){
        //   paymentStatus = true;
        //   invoice = callRespon;
        // });
      }
    } catch (error) {
      print('error pos invoice, ${error}');
      if (context.mounted) {
        alert.alertError(context, error.toString());
      }
    }
  }

  onPrintInvoiceBluetooth(bool reprint) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      bool result = false;
      List<int> ticket = await printInvoiceBluetooth(
        reprint ? 'reprint' : null,
        invoice,
        AppState().configPrinter,
        AppState().configCompany,
        AppState().configPosProfile,
        AppState().configUser,
      );

      result = await PrintBluetoothThermal.writeBytes(ticket);
    }
  }

  onPrintCheckerBluetooth(bool reprint) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      bool result = false;
      List<int> ticket = await printCheckerBluetooth(
        invoice,
        AppState().configPrinter,
        AppState().configApplication,
        reprint ? 'reprint' : null,
      );
      result = await PrintBluetoothThermal.writeBytes(ticket);
    }
  }

  onChangeDiscount() {
    if (selectedDiscount == 'additional_discount_percentage') {
      grandTotal = (bill * (1 - (discount / 100))).floor();
    } else {
      grandTotal = (bill - discount).floor();
    }

    setState(() {
      paymentMethod = '';
      payment = 0;
    });
  }
}
