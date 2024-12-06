import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/app_export.dart';
import 'package:kontena_pos/core/theme/custom_text_style.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/core/utils/print.dart';
import 'package:kontena_pos/widgets/custom_outlined_button.dart';
import 'package:kontena_pos/widgets/empty_data.dart';
import 'package:kontena_pos/widgets/filter_bar.dart';
import 'package:kontena_pos/widgets/list_cart.dart';
import 'package:kontena_pos/widgets/loading_content.dart';
import 'package:kontena_pos/widgets/searchbar.dart';
import 'package:kontena_pos/widgets/top_bar.dart';
import 'package:kontena_pos/core/api/frappe_thunder_pos/report_pos_invoice.dart'
    as FrappeFetchDataInvoice;
import 'package:kontena_pos/core/api/frappe_thunder_pos/pos_invoice.dart'
    as FrappeFetchGetDetailInvoice;
import 'package:kontena_pos/core/api/frappe_thunder_pos/cancel_pos_invoice.dart'
    as FrappeFetchCancelInvoice;
import 'package:kontena_pos/core/api/send_printer.dart' as sendToPrinter;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class HistoryInvoiceScreen extends StatefulWidget {
  const HistoryInvoiceScreen({Key? key}) : super(key: key);

  @override
  _HistoryInvoiceScreenState createState() => _HistoryInvoiceScreenState();
}

class _HistoryInvoiceScreenState extends State<HistoryInvoiceScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> tempPosOrder = [];
  List<dynamic> filterPayment = [];

  dynamic invoiceSelected;

  String search = '';
  String filter = '';

  bool isLoading = false;
  bool isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    onTapRefresh();
    onSetFilter();
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
            TopBar(
              isSelected: 'history',
              onTapRefresh: () {
                onTapRefresh();
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.left,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Searchbar(
                                  onChanged: (value) {
                                    setState(() {
                                      search = value;
                                    });
                                  },
                                  // selected: search,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 60.0, 8.0, 8.0),
                              child: FilterBar(
                                filterData: filterPayment,
                                fieldValue: 'mode_of_payment',
                                onFilterSelected: (String type) {
                                  if (type == 'All') {
                                    setState(() {
                                      filter = '';
                                    });
                                  } else {
                                    setState(() {
                                      filter = type;
                                    });
                                  }
                                },
                              ),
                            ),
                            if (isLoading == false)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 120.0, 8.0, 0.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(
                                    primary: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final history = tempPosOrder;
                                              final itemMenu = invoiceList(
                                                  history, search, filter);

                                              return itemMenu.isNotEmpty
                                                  ? AlignedGridView.count(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 6,
                                                      crossAxisSpacing: 6,
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          itemMenu.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final order =
                                                            itemMenu[index];
                                                        return InkWell(
                                                          onTap: () {
                                                            onTapAction(
                                                                context, order);
                                                          },
                                                          child: Card(
                                                            elevation: 2,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                    16.0,
                                                                    16.0,
                                                                    16.0,
                                                                    10.0,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            order['pos_invoice'],
                                                                            style:
                                                                                theme.textTheme.titleMedium,
                                                                          ),
                                                                          if (order['table'] !=
                                                                              null)
                                                                            Text(
                                                                              'Table ${order['table']}',
                                                                              style: theme.textTheme.bodyMedium,
                                                                            ),
                                                                          Text(
                                                                            order['status'].toString().toUpperCase(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: () {
                                                                                if (order['status'].toString().toLowerCase() == 'paid') {
                                                                                  return theme.colorScheme.onSecondary;
                                                                                } else if (order['status'].toString().toLowerCase() == 'consolidated') {
                                                                                  return appTheme.orange600;
                                                                                } else {
                                                                                  return theme.colorScheme.onPrimaryContainer;
                                                                                }
                                                                              }(),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            5.0,
                                                                        thickness:
                                                                            0.5,
                                                                        color: theme
                                                                            .colorScheme
                                                                            .outline,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            order['customer_name'].toString(),
                                                                            style:
                                                                                theme.textTheme.bodyMedium,
                                                                          ),
                                                                          Text(
                                                                            numberFormat('idr_fixed',
                                                                                order['grand_total']),
                                                                            style:
                                                                                TextStyle(
                                                                              color: theme.colorScheme.secondary,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          4.0,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  dateTimeFormat(
                                                                                    'dateui',
                                                                                    order['posting_date'],
                                                                                  ).toString(),
                                                                                  style: theme.textTheme.labelSmall,
                                                                                ),
                                                                                Text(
                                                                                  ' | ${timeFormat(
                                                                                    'time_simple',
                                                                                    order['posting_time'],
                                                                                  ).toString()}',
                                                                                  style: theme.textTheme.labelSmall,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              order['mode_of_payment'].toString().toUpperCase(),
                                                                              style: theme.textTheme.bodyMedium,
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
                                                        );
                                                      },
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(8.0,
                                                              100.0, 8.0, 0.0),
                                                      child: EmptyData(),
                                                    );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (isLoading)
                              const Align(
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: LoadingContent(),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          border: Border(
                            left: BorderSide(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15.0, 15.0, 15.0, 15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Detail Invoice',
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (invoiceSelected != null)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          invoiceSelected = null;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: theme.colorScheme.secondary,
                                        size: 24.0,
                                      ),
                                    ),
                                ],
                              ),
                              Divider(
                                height: 14.0,
                                thickness: 1.0,
                                color: theme.colorScheme.outline,
                              ),
                              if ((invoiceSelected != null) &&
                                  (isLoadingDetail == false))
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 16.0, 0.0, 0.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            invoiceSelected['name'],
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${invoiceSelected['customer_name']}',
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.secondary,
                                            ),
                                          ),
                                          Text(
                                            '${dateTimeFormat('dateui', invoiceSelected['posting_date'])} | ${timeFormat('time_simple', invoiceSelected['posting_time'])}',
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.secondary,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Divider(
                                            height: 14.0,
                                            thickness: 1.0,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                        '${invoiceSelected['payments'][0]['mode_of_payment']}'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 24.0,
                                                child: VerticalDivider(
                                                  thickness: 1.0,
                                                  color:
                                                      theme.colorScheme.outline,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                        ' ${(invoiceSelected['docstatus'] == 1) ? invoiceSelected['status'] : (invoiceSelected['docstatus'] == 2) ? 'Cancelled' : 'Draft'}',
                                                        style: TextStyle(
                                                      color: () {
                                                        if (invoiceSelected[
                                                                'docstatus'] ==
                                                            1) {
                                                          return theme
                                                              .colorScheme
                                                              .onSecondary;
                                                        } else if (invoiceSelected[
                                                                'docstatus'] ==
                                                            2) {
                                                          return theme
                                                              .colorScheme
                                                              .error;
                                                        } else {
                                                          return theme
                                                              .colorScheme
                                                              .onPrimaryContainer;
                                                        }
                                                      }(),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            height: 14.0,
                                            thickness: 1.0,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total',
                                              ),
                                              Text(numberFormat('idr_fixed',
                                                  invoiceSelected['total']))
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Discount ${(invoiceSelected['additional_discount_percentage'] != 0) ? '(${numberFormat('number_fixed', invoiceSelected['additional_discount_percentage'])}%)' : ''}',
                                              ),
                                              Text(
                                                numberFormat(
                                                  'idr_fixed',
                                                  invoiceSelected[
                                                      'discount_amount'],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Grand Total',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                numberFormat(
                                                    'idr_fixed',
                                                    invoiceSelected[
                                                        'grand_total']),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            height: 14.0,
                                            thickness: 1.0,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Pay',
                                              ),
                                              Text(numberFormat(
                                                  'idr_fixed',
                                                  invoiceSelected[
                                                      'paid_amount']))
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Change',
                                              ),
                                              Text((invoiceSelected[
                                                          'paid_amount'] >=
                                                      invoiceSelected[
                                                          'grand_total'])
                                                  ? numberFormat(
                                                      'idr_fixed',
                                                      (invoiceSelected[
                                                              'paid_amount'] -
                                                          invoiceSelected[
                                                              'grand_total']))
                                                  : numberFormat(
                                                      'idr_fixed', 0))
                                            ],
                                          ),
                                          Divider(
                                            height: 14.0,
                                            thickness: 1.0,
                                            color: theme.colorScheme.outline,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                itemCount:
                                                    invoiceSelected['items']
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  final itemData =
                                                      invoiceSelected['items']
                                                          [index];
                                                  return ListCart(
                                                    title:
                                                        "${itemData['item_name']} (${itemData['qty'].floor()})",
                                                    subtitle:
                                                        itemData['item_name'] ??
                                                            '-',
                                                    // addon: addon2,
                                                    // addons: addons,
                                                    qty: itemData['qty']
                                                        .floor()
                                                        .toString(),
                                                    catatan: '',
                                                    titleStyle: CustomTextStyles
                                                        .labelLargeBlack,
                                                    price: itemData['rate']
                                                        .toString(),
                                                    total: numberFormat(
                                                        'idr',
                                                        (itemData['qty'] *
                                                            itemData['rate'])),
                                                    priceStyle: CustomTextStyles
                                                        .labelLargeBlack,
                                                    labelStyle: CustomTextStyles
                                                        .bodySmallBluegray300,
                                                    editLabelStyle: TextStyle(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    note: '',
                                                    lineColor: appTheme.gray200,
                                                    secondaryStyle:
                                                        CustomTextStyles
                                                            .bodySmallGray,
                                                    isEdit: false,
                                                    // onTap: () => {},
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if ((invoiceSelected == null) &&
                                  (isLoadingDetail == false))
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 64.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Transaksi belum dipilih',
                                              style: TextStyle(
                                                color: theme.colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if ((invoiceSelected != null) &&
                                  (isLoadingDetail == false))
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Divider(
                                      height: 5.0,
                                      thickness: 0.5,
                                      color: theme.colorScheme.outline,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CustomOutlinedButton(
                                            height: 48.0,
                                            text: "Reprint Invoice",
                                            buttonTextStyle: TextStyle(
                                                color:
                                                    theme.colorScheme.primary),
                                            buttonStyle: CustomButtonStyles
                                                .outlinePrimary,
                                            onPressed: () {
                                              if (AppState().configPrinter[
                                                      'tipeConnection'] ==
                                                  'Bluetooth') {
                                                onPrintInvoiceBluetooth(true);
                                              } else {
                                                onPrintInvoice(true);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CustomOutlinedButton(
                                            height: 48.0,
                                            text: "Reprint Checker",
                                            buttonTextStyle: TextStyle(
                                                color:
                                                    theme.colorScheme.primary),
                                            buttonStyle: CustomButtonStyles
                                                .outlinePrimary,
                                            onPressed: () {
                                              if (AppState()
                                                      .configPrinter[
                                                          'tipeConnection']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'bluetooth') {
                                                onPrintCheckerBluetooth(true);
                                              } else {
                                                onPrintChecker(true);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (invoiceSelected['docstatus'] == 1)
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            CustomOutlinedButton(
                                              height: 48.0,
                                              text: "Void",
                                              buttonTextStyle: TextStyle(
                                                  color: theme.colorScheme
                                                      .primaryContainer),
                                              buttonStyle: CustomButtonStyles
                                                  .errorButton,
                                              onPressed: () {
                                                // onPrintChecker();
                                                onTapVoid(
                                                  context,
                                                  invoiceSelected,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              if (isLoadingDetail)
                                const Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: LoadingContent(),
                                  ),
                                ),
                            ],
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
      ),
    );
  }

  List<dynamic> invoiceList(List<dynamic> data, String search, String filter) {
    return data
        .where((item) =>
            (item['pos_invoice']
                    .toString()
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                item['customer_name']
                    .toString()
                    .toLowerCase()
                    .contains(search.toLowerCase())) &&
            item['mode_of_payment']
                .toString()
                .toLowerCase()
                .contains(filter.toLowerCase()))
        .toList();
    // print('data, $data');
  }

  onTapRefresh() async {
    // print('yes');
    setState(() {
      isLoading = true;
    });
    await onCallDataPosInvoice();
    setState(() {
      // isLoading = false;
    });
  }

  onTapAction(BuildContext context, dynamic item) async {
    // print('yes click');
    // setState
    setState(() {
      // invoiceSelected = item;
      isLoadingDetail = true;
    });
    await onCallDataPosInvoiceDetail(item);
    setState(() {});
  }

  onTapVoid(BuildContext context, dynamic item) async {
    setState(() {
      // isLoading = true;
      isLoadingDetail = true;
    });
    await onCallCancelPosOrder(item);
    setState(() {
      // isLoading = false;
      invoiceSelected = null;
    });
    onTapRefresh();
  }

  onCallDataPosInvoice() async {
    final FrappeFetchDataInvoice.ReportPosInvoice request =
        FrappeFetchDataInvoice.ReportPosInvoice(
      cookie: AppState().cookieData,
      reportName: 'POS History',
      filters:
          '{"company":"${AppState().configCompany['name']}","pos_profile":"${AppState().configPosProfile['name']}","owner":"${AppState().configUser['name']}","from_date":"2024-11-01","to_date":"${dateTimeFormat('date', null)}","user":"${AppState().configUser['email']}"}',
      orderBy: 'creation desc',
      limit: 200,
    );

    try {
      final callRequest =
          await FrappeFetchDataInvoice.request(requestQuery: request);

      // print('result, $callRequest');
      if (callRequest.isNotEmpty) {}
      setState(() {
        tempPosOrder = callRequest;
        tempPosOrder = tempPosOrder.reversed.toList();

        isLoading = false;

        if (tempPosOrder.isNotEmpty) {
          onSetAmount();
        }
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error call data pos invoice, $error');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallDataPosInvoiceDetail(dynamic invoice) async {
    final FrappeFetchGetDetailInvoice.PosInvoiceRequest reqPosInvoiceDetail =
        FrappeFetchGetDetailInvoice.PosInvoiceRequest(
            cookie: AppState().cookieData, id: invoice['pos_invoice']);

    try {
      final request = await FrappeFetchGetDetailInvoice.requestDetail(
          requestQuery: reqPosInvoiceDetail);

      if (request.isNotEmpty) {
        setState(() {
          invoiceSelected = request;
          isLoading = false;
          isLoadingDetail = false;
        });
      }

      // print('check detail, $request');

      // if (context.mounted) {
      //   Navigator.of(context).pushNamedAndRemoveUntil(
      //     AppRoutes.invoiceScreen,
      //     (route) => false,
      //   );
      // }
    } catch (error) {
      isLoadingDetail = false;
      isLoading = false;
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        if (context.mounted) {
          alertError(context, error.toString());
        }
      }
      return;
    }
  }

  onCallCancelPosOrder(dynamic paramItem) async {
    final FrappeFetchCancelInvoice.CancelPosInvoiceRequest request =
        FrappeFetchCancelInvoice.CancelPosInvoiceRequest(
      cookie: AppState().cookieData,
      id: paramItem['name'],
      status: paramItem['status'] == true ? 1 : 0,
    );

    try {
      final callCancelPosOrder =
          await FrappeFetchCancelInvoice.request(requestQuery: request);

      if (callCancelPosOrder.isNotEmpty) {
        if (context.mounted) {
          alertSuccess(context, 'Success, order confirm..');
        }
        setState(() {
          // AppState.resetOrderCart();
          // cartData = [];
          // // modeView = 'item';
          // cartSelected = null;
          // isLoadingContent = true;
          isLoadingDetail = false;
        });
        // onTapRefreshOrder();
      }
    } catch (error) {
      isLoadingDetail = false;
      print('check error, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onSetFilter() {
    // print('check, ${AppState().configPOSProfile}');
    setState(() {
      filterPayment = AppState().configPosProfile['payments'];
    });
    // print('check, $filterPayment');
  }

  onSetAmount() {
    List<dynamic> tmpFi = [];
    double tot = 0;
    for (var pay in filterPayment) {
      double tmp = 0;
      for (var pInv in tempPosOrder) {
        if (pInv['mode_of_payment'] == pay['mode_of_payment']) {
          tmp += pInv['paid_amount'];
          tot += pInv['paid_amount'];
        }
      }
      pay['amount'] = tmp;
      tmpFi.add(pay);
      // tmpFi.
    }
    setState(() {
      filterPayment = tmpFi;
    });
    print('check, ${tmpFi}');
  }

  onPrintChecker(bool reprint) async {
    dynamic docPrint = await printChecker(
      invoiceSelected,
      AppState().configPrinter,
      AppState().configApplication,
      reprint ? 'reprint' : null,
    );

    // print('print invoce, ${AppState().configPrinter}');

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
      print('error pos invoice, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onPrintInvoice(bool reprint) async {
    dynamic docPrint = await printInvoice(
        reprint ? 'reprint' : null,
        invoiceSelected,
        AppState().configPrinter,
        AppState().configCompany,
        AppState().configPosProfile,
        AppState().configUser);

    // print('print invoce, $docPrint');

    final sendToPrinter.ToPrint request = sendToPrinter.ToPrint(
      doc: docPrint,
      ipAddress: '127.0.0.1',
    );

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
        alertError(context, error.toString());
      }
    }
  }

  onPrintInvoiceBluetooth(bool reprint) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      bool result = false;
      List<int> ticket = await printInvoiceBluetooth(
        reprint ? 'reprint' : null,
        invoiceSelected,
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
        invoiceSelected,
        AppState().configPrinter,
        AppState().configApplication,
        reprint ? 'reprint' : null,
      );
      result = await PrintBluetoothThermal.writeBytes(ticket);
      print('result print, $result');
    }
  }
}
