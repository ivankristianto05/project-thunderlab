import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

import 'package:kontena_pos/core/api/frappe_thunder_pos/create_customer.dart'
    as frappeFetchDataCreateCustomer;
import 'package:kontena_pos/core/utils/alert.dart';

class CreateCustomerWidget extends StatefulWidget {
  CreateCustomerWidget({Key? key}) : super(key: key);

  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomerWidget> {
  TextEditingController customerName = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
                              'Create a New Customer',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.of(context).pop(false);
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
                                    color: theme.colorScheme.secondary,
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
                      // width: double.infinity,
                      // height: 48.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 6.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  // width: 280.0,
                                  height: 51.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: customerName,
                                    decoration: InputDecoration(
                                      hintText: 'Enter customer name',
                                      hintStyle: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 14.0,
                                      ),
                                      // filled: true,
                                      // fillColor: Colors.white,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                    ),
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (isLoading == true)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 8.0, 8.0),
                              child: Container(
                                width: double.infinity,
                                height: 48.0,
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
                                          width: 23,
                                          height: 23,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
                                              color: theme.colorScheme
                                                  .primaryContainer),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (isLoading == false)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 8.0, 8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  // onTapDone(context);
                                  onTapSave(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  alignment:
                                      const AlignmentDirectional(0.00, 0.00),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4.0, 4.0, 4.0, 4.0),
                                    child: Text(
                                      'Add Customer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.primaryContainer,
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
        ],
      ),
    );
  }

  onTapSave(BuildContext context) async {
    print('save');
    setState(() {
      isLoading = true;
      // AppState().customerSelected = ;
    });

    await onCallCreateCustomer();
    Navigator.pop(context);
  }

  onCallCreateCustomer() async {
    final frappeFetchDataCreateCustomer.CreateCustomer request =
        frappeFetchDataCreateCustomer.CreateCustomer(
      cookie: AppState().cookieData,
      customerName: customerName.text,
      customerGroup: 'Individual',
      customerType: 'Individual',
      territory: 'All Territories',
    );

    try {
      // Add a timeout of 30 seconds to the profile request
      final callRequest = await frappeFetchDataCreateCustomer.request(
        requestQuery: request,
      );

      if (callRequest.isNotEmpty) {
        print('call request, ${callRequest}');
        setState(() {
          AppState().customerSelected = callRequest;
          // if (search.text.isEmpty) {
          //   AppState().dataCustomer = callRequest;
          // }
          // customerDisplay = callRequest;
          isLoading = false;
        });
        alertSuccess(context, 'Success add new customer');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        alertError(context, error.toString());
        print(error);
      }
      return;
    }
  }
}
