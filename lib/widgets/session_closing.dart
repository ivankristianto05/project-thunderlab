import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';

import 'package:kontena_pos/core/api/frappe_thunder_pos/create_closing_entry.dart'
    as FrappeFetchCreateClosingEntry;
import 'package:kontena_pos/core/api/frappe_thunder_pos/entry_closing.dart'
    as FrappeFetchEntryClosing;

class SessionClosing extends StatefulWidget {
  SessionClosing({
    Key? key,
    required this.dataSession,
  }) : super(key: key);

  final List<dynamic> dataSession;

  @override
  _SessionClosingState createState() => _SessionClosingState();
}

class _SessionClosingState extends State<SessionClosing> {
  List<dynamic> invoiceSession = [];
  List<dynamic> paymentSession = [];
  List<dynamic> dataSession = [];

  double total = 0;

  bool isLoading = false;

  String closingPosId = '';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // reinitSession();
  }

  @override
  void initState() {
    super.initState();
    // onCallEntryClosingInvoice();
    onInit();
    // reinitSession();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.65,
                height: MediaQuery.sizeOf(context).height * 0.6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Text(
                              'Detail Session Cashier',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.of(context).pop();
                              // context.pushNamed('HomePage');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: theme.colorScheme.onBackground,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: theme.colorScheme.outline,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              // decoration: BoxDecoration(
                              //   color: theme.colorScheme,
                              // ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 24.0, 16.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'List Invoices:',
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.secondary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Container(
                                            decoration: const BoxDecoration(),
                                            child: Container(),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 12.0, 0.0, 16.0),
                                            child: Builder(
                                              builder: (context) {
                                                final invoiceDisplay =
                                                    invoiceSession;
                                                // setState(() {
                                                // totalAmountInvoice = 0;

                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (invoiceDisplay
                                                        .isNotEmpty)
                                                      ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            invoiceDisplay
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final currentInvoice =
                                                              invoiceDisplay[
                                                                  index];
                                                          final totalPaid =
                                                              currentInvoice[
                                                                      'paid_amount'] -
                                                                  currentInvoice[
                                                                      'change_amount'];
                                                          return Column(
                                                            children: [
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                    12.0,
                                                                    12.0,
                                                                    12.0,
                                                                    12.0,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          currentInvoice[
                                                                              'name'],
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                theme.colorScheme.secondary,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          currentInvoice[
                                                                              'customer_name'],
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                theme.colorScheme.secondary,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          currentInvoice[
                                                                              'mode_of_payment'],
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                theme.colorScheme.secondary,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          numberFormat(
                                                                              'idr_fixed',
                                                                              totalPaid),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                theme.colorScheme.secondary,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 1.0,
                                                                thickness: 1.0,
                                                                color: theme
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    if (invoiceDisplay.isEmpty)
                                                      Container(
                                                        width: double.infinity,
                                                        height: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: theme
                                                                    .colorScheme
                                                                    .surface),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  8.0,
                                                                  4.0,
                                                                  8.0,
                                                                  4.0),
                                                          child: Text(
                                                            'No Transaction',
                                                            style: TextStyle(
                                                                color: theme
                                                                    .colorScheme
                                                                    .onPrimaryContainer),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 30.0,
                                      // decoration: BoxDecoration(
                                      //     color:
                                      //         theme.colorScheme.surface),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(24.0, 8.0, 24.0, 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              numberFormat('idr_fixed', total),
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // width: 60.0,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.background),
                              child: SingleChildScrollView(
                                primary: true,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 24.0, 8.0, 4.0),
                                      child: Text(
                                        'Payments:',
                                        style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8.0, 16.0, 8.0, 8.0),
                                      child: Builder(
                                        builder: (context) {
                                          final paymentDisplay = paymentSession;
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (paymentDisplay.isNotEmpty)
                                                ListView.builder(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      paymentDisplay.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final currentPayment =
                                                        paymentDisplay[index];
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              currentPayment[
                                                                  'mode_of_payment'],
                                                              style: TextStyle(
                                                                color: theme
                                                                    .colorScheme
                                                                    .secondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              numberFormat(
                                                                  'idr_fixed',
                                                                  currentPayment[
                                                                      'amount']),
                                                              style: TextStyle(
                                                                color: theme
                                                                    .colorScheme
                                                                    .secondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8.0),
                                                      ],
                                                    );
                                                  },
                                                )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                    if (isLoading == false)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: CustomElevatedButton(
                            text: "Close Cashier",
                            buttonTextStyle: TextStyle(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            buttonStyle: CustomButtonStyles.primary,
                            onPressed: () {
                              // addToCart(
                              //   context,
                              //   widget.dataMenu,
                              //   selectedVarian,
                              //   selectedAddon,
                              //   notesController.text,
                              //   int.parse(qtyController.text),
                              // );
                              onTapClosing();
                            },
                          ),
                        ),
                      ),
                    if (isLoading == true)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(
                                        color:
                                            theme.colorScheme.primaryContainer),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getMetodePayment(List<dynamic> payments) {
    String tmp = '';
    // Filter items dengan `amount` > 0
    var filteredItems = payments.where((item) => item["amount"] > 0).toList();

    // Gabungkan menjadi teks dengan delimiter koma
    var result = filteredItems
        .map((item) => item['mode_of_payment'].toString())
        .join(", ");

    return result;
  }

  reinitSession() async {
    List<dynamic> defaultMethod = AppState().configPosProfile['payments'];
    List<dynamic> payments = [];
    double totalInvoice = 0;
    List<dynamic> invoice = dataSession
        .map((item) {
          return {
            "name": item["name"],
            "pos_invoice": item['name'],
            "customer": item['customer'],
            "customer_name": item["customer_name"],
            "paid_amount": item["paid_amount"],
            "change_amount": item["change_amount"],
            "grand_total": item["grand_total"],
            "mode_of_payment": getMetodePayment(item['payments']),
          };
        })
        .toList()
        .reversed
        .toList();

    for (var method in defaultMethod) {
      payments.add({
        'mode_of_payment': method['mode_of_payment'],
        'amount': 0,
        'opening_amount': 0,
        'closing_amount': 0,
        'expected_amount': 0,
      });
    }

    // totalAmountInvoice = 0;

    for (var pay in payments) {
      String mode = pay['mode_of_payment'];
      double totalAmount = 0;

      for (var invoice in dataSession) {
        for (var payGroup in invoice['payments']) {
          // print('paygroup ${payGroup.runtimeType}');
          // print('paygroup ${payGroup}');
          // for (var paym in payGroup) {
          if (payGroup['mode_of_payment'].toString().toLowerCase() ==
              mode.toString().toLowerCase()) {
            totalAmount += payGroup['amount'];
          }
          // }
        }
        // if (invoice['mode_of_payments'])
        if ((totalAmount > 0) &&
            (mode.toString().toLowerCase().contains('cash'))) {
          print('check change amount, ${invoice['change_amount']}');
          print('check total amount, ${totalAmount}');
          totalAmount -= invoice['change_amount'];
        }
      }

      totalInvoice += totalAmount;

      pay['amount'] = totalAmount;
      // pay['closing_amount'] = totalAmount;
      // pay['expected_amount'] = totalAmount;
    }

    setState(() {
      invoiceSession = invoice;
      paymentSession = payments;
      total = totalInvoice;
    });

    print('check payment session, ${paymentSession}');
  }

  onInit() async {
    setState(() {
      isLoading = true;
    });
    await onCallEntryClosingInvoice();
    await reinitSession();
    setState(() {
      isLoading = false;
    });
  }

  onTapClosing() async {
    setState(() {
      isLoading = true;
    });
    await onCallCreateClosingEntry();
    if (closingPosId != '') {
      await onCallSubmitClosingEntry();
      setState(() {
        // AppState().sessionCashier = null;
      });
      Navigator.pop(context);
    }
  }

  onCallCreateClosingEntry() async {
    final FrappeFetchCreateClosingEntry.CreateClosingEntry request =
        FrappeFetchCreateClosingEntry.CreateClosingEntry(
      cookie: AppState().cookieData,
      periodStart: AppState().sessionCashier['period_start_date'],
      periodEnd:
          '${dateTimeFormat('date', null).toString()} ${timeFormat('time_full', null).toString()}',
      postingDate: dateTimeFormat('date', null).toString(),
      posOpeningId: AppState().sessionCashier['name'],
      company: AppState().configCompany['name'],
      posProfile: AppState().configPosProfile['name'],
      user: AppState().configUser['name'],
      posTransaction: invoiceSession,
      listPayment: paymentSession,
      total: total,
    );

    try {
      final callApi =
          await FrappeFetchCreateClosingEntry.request(requestQuery: request);
      if (callApi.isNotEmpty) {
        // print('response, ${callApi}');
        setState(() {
          closingPosId = callApi['name'];
        });
        // alertSuccess(context, 'Success, closing cashier');
        // isLoading = true;
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallSubmitClosingEntry() async {
    final FrappeFetchCreateClosingEntry.CreateClosingEntry request =
        FrappeFetchCreateClosingEntry.CreateClosingEntry(
      cookie: AppState().cookieData,
      periodStart: AppState().sessionCashier['period_start_date'],
      periodEnd:
          '${dateTimeFormat('date', null).toString()} ${timeFormat('time_full', null).toString()}',
      postingDate: dateTimeFormat('date', null).toString(),
      posOpeningId: AppState().sessionCashier['name'],
      company: AppState().configCompany['name'],
      posProfile: AppState().configPosProfile['name'],
      user: AppState().configUser['name'],
      id: closingPosId,
    );

    try {
      final callApi =
          await FrappeFetchCreateClosingEntry.submit(requestQuery: request);
      if (callApi.isNotEmpty) {
        // print('response, ${callApi}');
        setState(() {
          closingPosId = callApi['name'];
        });
        AppState().update(() {
          AppState().sessionCashier = null;
        });
        alertSuccess(context, 'Success, closing cashier');

        isLoading = true;
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallEntryClosingInvoice() async {
    final FrappeFetchEntryClosing.EntryClosing request =
        FrappeFetchEntryClosing.EntryClosing(
      cookie: AppState().cookieData,
      periodStart: AppState().sessionCashier['period_start_date'],
      periodEnd:
          '${dateTimeFormat('date', null).toString()} ${timeFormat('time_full', null).toString()}',
      postingDate: dateTimeFormat('date', null).toString(),
      posOpeningId: AppState().sessionCashier['name'],
      company: AppState().configCompany['name'],
      posProfile: AppState().configPosProfile['name'],
      user: AppState().configUser['name'],
    );

    try {
      final callApi =
          await FrappeFetchEntryClosing.request(requestQuery: request);
      if (callApi.isNotEmpty) {
        setState(() {
          dataSession = callApi;
        });
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }
}
