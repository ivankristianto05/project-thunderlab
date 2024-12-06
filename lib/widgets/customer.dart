import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/api/frappe_thunder_pos/customer.dart'
    as frappeFetchDataCustomer;
import 'package:kontena_pos/widgets/empty_data.dart';
class CustomerList extends StatefulWidget {
  dynamic selected;
  CustomerList({
    super.key,
    this.selected,
  });
  @override
  _CustomerListState createState() => _CustomerListState();
}
class _CustomerListState extends State<CustomerList> {
  TextEditingController search = TextEditingController();
  TextEditingController guestNameController = TextEditingController();
  bool isGuest = false;

  List<dynamic> customerDisplay = [];
  dynamic customerSelect;
  bool isLoading = false;
  String searchCustomer = '';

  @override
  void initState() {
    super.initState();

    onRefresh();
    onReinitSelected();
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
                height: MediaQuery.sizeOf(context).height * 0.65,
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
                              'Select Customer',
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
                    SizedBox(
                      width: double.infinity,
                      height: 96,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: search,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontSize: 14.0,
                              ),
                              // filled: true,
                              // fillColor: Colors.white,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(12.0),
                              // isDense: true,
                              suffixIcon: search.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        setState(() {
                                          search.text = '';
                                          search.clear();
                                        });
                                        onSearch();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: theme.colorScheme.secondary,
                                        size: 18.0,
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              EasyDebounce.debounce(
                                  'search', const Duration(milliseconds: 300),
                                  () {
                                setState(() {
                                  search.text = value;
                                });
                                // widget.onChanged!(enterSearch.text);
                              });
                              onSearch();
                            },
                            // onEditingComplete: onCompletedChange,
                          ),
                         TextField(
                          controller: guestNameController,
                          enabled: isGuest, // Kondisi apakah bisa diisi
                          decoration: InputDecoration(
                            hintText: 'Masukkan Nama Customer',
                            hintStyle: TextStyle(
                              color: isGuest
                                  ? theme.colorScheme.onPrimaryContainer
                                  : Colors.grey, // Warna untuk disabled
                              fontSize: 14.0,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12.0),
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
                      child: Column(
                        children: [
                          if (customerDisplay.isNotEmpty)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Builder(
                                  builder: (context) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: customerDisplay.length,
                                      itemBuilder: (context, index) {
                                        final currentCustomer =
                                            customerDisplay[index];
                                        return InkWell(
                                          onTap: () {
                                            onTapCustomer(
                                                context, currentCustomer);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: ((customerSelect !=
                                                          null) &&
                                                      (customerSelect['name'] ==
                                                          currentCustomer[
                                                              'name']))
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme
                                                      .primaryContainer,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 8.0, 12.0, 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        currentCustomer[
                                                            'customer_name'],
                                                        style: TextStyle(
                                                          color: ((customerSelect !=null) && (customerSelect['name'] ==currentCustomer['name']))
                                                              ? theme
                                                                  .colorScheme
                                                                  .primaryContainer
                                                              : theme
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                      if ((customerSelect !=null) && (customerSelect['name'] ==currentCustomer['name']))
                                                        Icon(
                                                          Icons.check,
                                                          color: theme
                                                              .colorScheme
                                                              .primaryContainer,
                                                          size: 24.0,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1.0,
                                                  thickness: 1.0,
                                                  color:
                                                      theme.colorScheme.outline,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          if (customerDisplay.isEmpty) EmptyData(),
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
                                onTapDone(context);
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4.0, 4.0, 4.0, 4.0),
                                  child: Text(
                                    'Pick Customer',
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
        ],
      ),
    );
  }

  onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await onCallCustomer();
  }

  onReinit() {
    setState(() {
      customerDisplay = AppState().dataCustomer;
    });
  }

  onReinitSelected() {
    if (widget.selected != null) {
      setState(() {
        customerSelect = widget.selected;
      });
    }
  }

  onTapCustomer(BuildContext context, dynamic customer) {
  setState(() {
    customerSelect = customer;
    isGuest = customer['customer_name'] == 'Guest';
    if (!isGuest) {
      guestNameController.clear(); // Kosongkan TextField jika bukan Guest
    }
  });
}

  onSearch() async {
    setState(() {
      isLoading = true;
    });
    if (search.text.isNotEmpty) {
      await onCallCustomer();
    } else {
      setState(() {
        customerDisplay = AppState().dataCustomer;
        isLoading = false;
      });
    }
  }

  onTapDone(BuildContext context) {
    setState(() {
      AppState().customerSelected = customerSelect;
    });

    Navigator.pop(context);
  }

  onCallCustomer() async {
    final frappeFetchDataCustomer.Customer request =
        frappeFetchDataCustomer.Customer(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: '[["customer_name","like","%${search.text}%"]]',
      limit: 50,
    );

    try {
      // Add a timeout of 30 seconds to the profile request
      final callRequest = await frappeFetchDataCustomer.request(
        requestQuery: request,
      );

      if (callRequest.isNotEmpty) {
        setState(() {
          if (search.text.isEmpty) {
            AppState().dataCustomer = callRequest;
          }
          customerDisplay = callRequest;
          isLoading = false;
        });
      }
    } catch (error) {
      // isLoading = false;
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        print(error);
      }
      return;
    }
  }
}
