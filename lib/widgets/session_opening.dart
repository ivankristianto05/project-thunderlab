import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';

import 'package:kontena_pos/core/api/frappe_thunder_pos/create_opening_entry.dart'
    as FrappeFetchCreateOpeningEntry;

class SessionOpening extends StatefulWidget {
  SessionOpening({
    Key? key,
  }) : super(key: key);

  @override
  _SessionOpeningState createState() => _SessionOpeningState();
}

class _SessionOpeningState extends State<SessionOpening> {
  TextEditingController amountController = TextEditingController();

  List<dynamic> invoiceSession = [];
  List<dynamic> paymentSession = [];
  List<dynamic> dataSession = [];
  List<dynamic> paymentOpening = [];

  double totalAmountInvoice = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      amountController.text = '0';
    });
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
                width: MediaQuery.sizeOf(context).width * 0.3,
                height: MediaQuery.sizeOf(context).height * 0.5,
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
                              'Open Session Cashier',
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
                    SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Amount',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontSize: 14.0,
                              ),
                              // filled: true,
                              // fillColor: Colors.white,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(12.0),
                              // isDense: true,
                            ),
                            onChanged: (value) {
                              EasyDebounce.debounce(
                                  'search', const Duration(milliseconds: 300),
                                  () {
                                // setState(() {
                                amountController.text = value;
                                // });
                                // widget.onChanged!(enterSearch.text);
                              });
                              // onSearch();
                            },
                            onEditingComplete: () {
                              // String tmp = numberFormat(
                              //     'number_fixed', amountController.text);
                              // amountController.text = numberFormat(
                              // print('check tmp, $tmp');
                              //     'idr_fixed', amountController.text);
                            },
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
                      // width: double.infinity,
                      // height: 48.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // TextField(
                          //   controller: amount,
                          //   decoration: InputDecoration(
                          //     hintText: 'Amount',
                          //     hintStyle: TextStyle(
                          //       color: theme.colorScheme.onPrimaryContainer,
                          //       fontSize: 14.0,
                          //     ),
                          //     // filled: true,
                          //     // fillColor: Colors.white,
                          //     border: InputBorder.none,
                          //     contentPadding: const EdgeInsets.all(12.0),
                          //     // isDense: true,
                          //   ),
                          //   onChanged: (value) {
                          //     EasyDebounce.debounce(
                          //         'search', const Duration(milliseconds: 300),
                          //         () {
                          //       setState(() {
                          //         amount.text = value;
                          //       });
                          //       // widget.onChanged!(enterSearch.text);
                          //     });
                          //     // onSearch();
                          //   },
                          //   // onEditingComplete: onCompletedChange,
                          // ),
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
                            text: "Open Cashier",
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
                              onTapOpening();
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

  onInit() async {
    setState(() {
      // isLoading = true;
    });
    amountController.text = '0';
    // await onCallEntryClosingInvoice();
    // await reinitSession();
    // setState(() {
    //   isLoading = false;
    // });
  }

  onTapOpening() async {
    setState(() {
      isLoading = true;
    });

    List<dynamic> payment = AppState().configPosProfile['payments'];
    List<dynamic> tmp = [];
    for (var pay in payment) {
      if (pay['mode_of_payment'].toString().toLowerCase().contains('cash')) {
        tmp.add({
          'mode_of_payment': pay['mode_of_payment'],
          'opening_amount': amountController.text ?? 0,
        });
      }
    }
    setState(() {
      paymentOpening = tmp;
    });

    await onCallCreateOpeningEntry();
    // if (closingPosId != '') {
    //   await onCallSubmitClosingEntry();
    //   setState(() {
    //     AppState().sessionCashier = null;
    //   });
    // }
    // Navigator.pop(context);
  }

  onCallCreateOpeningEntry() async {
    final FrappeFetchCreateOpeningEntry.CreateOpeningEntry request =
        FrappeFetchCreateOpeningEntry.CreateOpeningEntry(
      cookie: AppState().cookieData,
      periodStart:
          '${dateTimeFormat('date', null).toString()} ${timeFormat('time_full', null).toString()}',
      postingDate: dateTimeFormat('date', null).toString(),
      company: AppState().configCompany['name'],
      posProfile: AppState().configPosProfile['name'],
      user: AppState().configUser['name'],
      balance: paymentOpening,
    );

    try {
      final callApi =
          await FrappeFetchCreateOpeningEntry.request(requestQuery: request);
      if (callApi.isNotEmpty) {
        alertSuccess(context, 'Success opening cashier');
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
    } catch (error) {
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }
}
