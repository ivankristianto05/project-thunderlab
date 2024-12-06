import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kontena_pos/core/api/frappe_thunder_pos/pos_invoice.dart'
    as FrappeFetchDataGetInvoice;
import 'package:kontena_pos/core/api/frappe_thunder_pos/item.dart'
    as FrappeFetchDataItem;
import 'package:kontena_pos/core/api/frappe_thunder_pos/item_group.dart'
    as FrappeFetchDataItemGroup;
import 'package:kontena_pos/core/api/frappe_thunder_pos/item_price.dart'
    as FrappeFetchDataItemPrice;
import 'package:kontena_pos/core/api/frappe_thunder_pos/pos_cart.dart'
    as FrappeFetchDataGetCart;
import 'package:kontena_pos/core/api/frappe_thunder_pos/pos_order.dart'
    as FrappeFetchDataGetOrder;
import 'package:kontena_pos/core/api/frappe_thunder_pos/pos_delivery.dart'
    as FrappeFetchDataGetDelivery;
import 'package:kontena_pos/core/api/frappe_thunder_pos/create_pos_cart.dart'
    as FrappeFetchCreateCart;
import 'package:kontena_pos/core/api/frappe_thunder_pos/create_pos_order.dart'
    as FrappeFetchCreateOrder;
import 'package:kontena_pos/core/api/frappe_thunder_pos/submit_pos_order.dart'
    as FrappeFetchSubmitOrder;
import 'package:kontena_pos/core/api/frappe_thunder_pos/cancel_pos_order.dart'
    as FrappeFetchCancelOrder;
import 'package:kontena_pos/core/api/frappe_thunder_pos/submit_pos_delivery.dart'
    as FrappeFetchSubmitDelivery;
import 'package:kontena_pos/core/api/frappe_thunder_pos/delete_pos_order.dart'
    as FrappeFetchDeleteOrder;
import 'package:kontena_pos/core/api/send_printer.dart' as sendToPrinter;

import 'package:flutter/material.dart';
import 'package:kontena_pos/core/app_export.dart';
import 'package:kontena_pos/core/functions/order_new.dart';
import 'package:kontena_pos/core/functions/reformat_item_with_price.dart';
import 'package:kontena_pos/core/theme/custom_text_style.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';
import 'package:kontena_pos/core/utils/print.dart';
import 'package:kontena_pos/features/cart/persentation/add_to_cart.dart';
import 'package:kontena_pos/features/orders/persentation/bottom_navigation.dart';
import 'package:kontena_pos/features/products/persentation/product_grid.dart';
import 'package:kontena_pos/widgets/create_customer.dart';
import 'package:kontena_pos/widgets/custom_dialog.dart';
import 'package:kontena_pos/widgets/custom_outlined_button.dart';
import 'package:kontena_pos/widgets/customer.dart';
import 'package:kontena_pos/widgets/empty_cart.dart';
import 'package:kontena_pos/widgets/empty_data.dart';
import 'package:kontena_pos/widgets/filter_bar.dart';
import 'package:kontena_pos/widgets/loading_content.dart';
import 'package:kontena_pos/widgets/searchbar.dart';
import 'package:kontena_pos/widgets/table_number.dart';
import 'package:kontena_pos/widgets/top_bar.dart';
import 'package:kontena_pos/widgets/type_transaction.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:styled_divider/styled_divider.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  OrderCart cart = OrderCart();
  TextEditingController enterGuestNameController = TextEditingController();

  String? table;
  String? pickupType;
  String typeTransaction = 'dine-in';
  String tableNumber = '1';
  String modeView = 'order';
  String filterItemDefault = '';
  String filterItemGroupSelected = '';
  String search = '';
  String filter = '';
  String? guestName;

  bool isLoading = true;
  bool isLoadingContent = false;
  bool isLoadingDetail = false;

  late Map cartRecapData;

  late List<OrderCartItem> cartData;
  List<dynamic> itemGroupDisplay = [];
  List<dynamic> itemDisplay = [];
  List<dynamic> orderDisplay = [];
  List<dynamic> servedDisplay = [];
  List<dynamic> tempPosCart = [];
  List<dynamic> tempPosOrder = [];
  List<dynamic> tempPosServed = [];

  dynamic cartSelected;
  dynamic orderCartSelected;
  dynamic servesSelected;
  dynamic customerSelected;

  //final soLoud = SoLoud.instance;

  DateTime? lastOrderTimestamp;
  Timer? timer;

  // SoundProps? currentSound;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    cartData = cart.getAllItemCart();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // _initializeAudio();
    });
    // enterGuestNameController.addListener(_updateState);

    if (AppState().dataItem.isEmpty) {
      onTapRefreshMenu();
    }

    if (orderDisplay.isEmpty) {
      onTapRefreshOrder();
    }

    if (servedDisplay.isEmpty) {
      onTapRefreshHistory();
    }

    setState(() {
      cartData = cart.getAllItemCart();
      AppState().typeTransaction = 'dine-in';
      typeTransaction = 'dine-in';
      AppState().tableNumber = '1';
      tableNumber = '1';
      itemGroupDisplay = AppState().configPosProfile['item_groups'];
      filterItemDefault = itemGroupDisplay
          .map((itemGroup) => '"${itemGroup['item_group']}"')
          .join(', ');
    });

    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (modeView == 'served') {
        //print('yes timer period dari served');
        onTapRefreshHistory();
      }
    });
  }

  // void _initializeAudio() async {
  //   await soLoud.init();
  // }

  @override
  void dispose() {
    // enterGuestNameController.removeListener(_updateState);
    // enterGuestNameController.dispose();
    timer?.cancel();
    //soLoud.disposeAllSources();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            TopBar(
              isSelected: 'order',
              onTapRefresh: () {
                if (modeView == 'order') {
                  onTapRefreshMenu();
                } else if (modeView == 'confirm') {
                  onTapRefreshOrder();
                } else if (modeView == 'served') {
                  onTapRefreshHistory();
                }
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            if (modeView == 'order')
                              Column(
                                children: [
                                  Searchbar(
                                    onChanged: (value) {
                                      setState(() {
                                        search = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            if (modeView == 'order')
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 60.0, 8.0, 8.0),
                                child: FilterBar(
                                  filterData: itemGroupDisplay,
                                  fieldValue: 'item_group',
                                  onFilterSelected: (String type) {
                                    setState(() {
                                      if (type == 'All') {
                                        filter = '';
                                      } else {
                                        filter = type;
                                      }
                                    });
                                  },
                                ),
                              ),
                            if (modeView == 'order' &&
                                isLoadingContent == false)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 120.0, 8.0, 0.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SingleChildScrollView(
                                    // primary: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Column(
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              final produk =
                                                  AppState().dataItem;
                                              final itemMenu = menu(
                                                produk,
                                                search,
                                                filter,
                                              );
                                              return (itemMenu.isNotEmpty)
                                                  ? AlignedGridView.count(
                                                      crossAxisCount: MediaQuery
                                                                      .sizeOf(
                                                                          context)
                                                                  .width >
                                                              930
                                                          ? 4
                                                          : 5, // Jumlah kolom
                                                      mainAxisSpacing: 6,
                                                      crossAxisSpacing: 6,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          itemMenu.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final currentItem =
                                                            itemMenu[index];
                                                        bool isVisible =
                                                            onSearchFilterMenu(
                                                                    currentItem[
                                                                        'item_name'],
                                                                    search)!
                                                                ? true
                                                                : false;

                                                        return ProductGrid(
                                                          name: currentItem[
                                                                  'item_name'] ??
                                                              '',
                                                          category: currentItem[
                                                                  'item_group'] ??
                                                              '',
                                                          price: numberFormat(
                                                              'idr',
                                                              currentItem[
                                                                  'standard_rate']),
                                                          image:
                                                              CustomImageView(
                                                            imagePath:
                                                                ImageConstant
                                                                    .imgAdl1,
                                                            height: 90.v,
                                                            width: 70.h,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        1.v),
                                                          ),
                                                          onTap: () {
                                                            onTapOpenItem(
                                                              context,
                                                              currentItem,
                                                            );
                                                          },
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
                            if (modeView == 'confirm' &&
                                isLoadingContent == false)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SingleChildScrollView(
                                    primary: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          if (orderDisplay.isNotEmpty)
                                            AlignedGridView.count(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 6,
                                              crossAxisSpacing: 6,
                                              shrinkWrap: true,
                                              primary: false,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: orderDisplay.length,
                                              itemBuilder: (context, index) {
                                                final order =
                                                    orderDisplay[index];
                                                dynamic orderItemList =
                                                    order['items'];
                                                return InkWell(
                                                  onTap: () {
                                                    addToCartFromOrder(
                                                        context, order);
                                                  },
                                                  child: Card(
                                                    elevation: 2,
                                                    child: Column(
                                                      children: [
                                                        if ((cartSelected !=
                                                                null) &&
                                                            (cartSelected[
                                                                    'name'] ==
                                                                order['name']))
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 24.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: theme
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      4.0),
                                                              child: Text(
                                                                'Selected',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    order[
                                                                        'name'],
                                                                    style: theme
                                                                        .textTheme
                                                                        .titleMedium,
                                                                  ),
                                                                  Text(
                                                                    'Table ${order['table']}',
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    order['customer_name']
                                                                        .toString(),
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  4.0,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      dateTimeFormat(
                                                                        'dateui',
                                                                        order[
                                                                            'date'],
                                                                      ).toString(),
                                                                      style: theme
                                                                          .textTheme
                                                                          .labelSmall,
                                                                    ),
                                                                    Text(
                                                                      ' | ${dateTimeFormat(
                                                                        'time',
                                                                        order[
                                                                            'creation'],
                                                                      ).toString()}',
                                                                      style: theme
                                                                          .textTheme
                                                                          .labelSmall,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 5.0,
                                                                thickness: 0.5,
                                                                color: theme
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  4.0,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    ListView
                                                                        .separated(
                                                                      primary:
                                                                          false,
                                                                      separatorBuilder:
                                                                          (context, index) =>
                                                                              Divider(
                                                                        height:
                                                                            12,
                                                                        thickness:
                                                                            0.5,
                                                                        color: theme
                                                                            .colorScheme
                                                                            .outline,
                                                                      ),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          orderItemList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              idx) {
                                                                        dynamic
                                                                            orderItem =
                                                                            orderItemList[idx];
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 8.0),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${orderItem['qty']}x",
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 8),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    AutoSizeText(
                                                                                      "${orderItem['item_name']} - ${orderItem['variant'] ?? ''}",
                                                                                      style: theme.textTheme.titleMedium,
                                                                                      maxLines: 2, // Allows up to 2 lines
                                                                                      minFontSize: 10,
                                                                                      maxFontSize: 14,
                                                                                      overflow: TextOverflow.ellipsis, // Ellipsis if it exceeds 2 lines
                                                                                    ),
                                                                                    const SizedBox(height: 4),
                                                                                    if ((orderItem.containsKey('note')) && (orderItem['note'] != null) && (orderItem['note'] != ''))
                                                                                      AutoSizeText(
                                                                                        "Notes: ${orderItem['note']}",
                                                                                        style: theme.textTheme.labelSmall,
                                                                                        maxLines: 2,
                                                                                        minFontSize: 10,
                                                                                        maxFontSize: 12,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                (orderItem['docstatus'] == 1)
                                                                                    ? 'Confirm'
                                                                                    : (orderItem['docstatus'] == 2)
                                                                                        ? 'Cancelled'
                                                                                        : 'Draft',
                                                                                style: (orderItem['docstatus'] != 1)
                                                                                    ? TextStyle(
                                                                                        color: () {
                                                                                          if (orderItem['docstatus'] == 1) {
                                                                                            return theme.colorScheme.primary;
                                                                                          } else if (orderItem['docstatus'] == 2) {
                                                                                            return theme.colorScheme.error;
                                                                                          } else {
                                                                                            return theme.colorScheme.onPrimaryContainer;
                                                                                          }
                                                                                        }(),
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 12,
                                                                                      )
                                                                                    : TextStyle(
                                                                                        color: theme.colorScheme.primary,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
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
                                            ),
                                          if (orderDisplay.isEmpty) EmptyData(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (modeView == 'served' && isLoadingContent == false)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SingleChildScrollView(
                                    primary: true,
                                    // scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (servedDisplay.isNotEmpty)
                                            AlignedGridView.count(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 6,
                                              crossAxisSpacing: 6,
                                              shrinkWrap: true,
                                              primary: false,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: servedDisplay.length,
                                              itemBuilder: (context, index) {
                                                final order =
                                                    servedDisplay[index];
                                                dynamic orderItemList =
                                                    order['items'];
                                                return InkWell(
                                                  onTap: () {
                                                    addToCartFromOrder(
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
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    order[
                                                                        'name'],
                                                                    style: theme
                                                                        .textTheme
                                                                        .titleMedium,
                                                                  ),
                                                                  if (order[
                                                                          'table'] !=
                                                                      null)
                                                                    Text(
                                                                      'Table ${order['table']}',
                                                                      style: theme
                                                                          .textTheme
                                                                          .bodyMedium,
                                                                    ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                height: 5.0,
                                                                thickness: 0.5,
                                                                color: theme
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    order['customer_name']
                                                                        .toString(),
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyMedium,
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  4.0,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      dateTimeFormat(
                                                                        'dateui',
                                                                        order[
                                                                            'date'],
                                                                      ).toString(),
                                                                      style: theme
                                                                          .textTheme
                                                                          .labelSmall,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 5.0,
                                                                thickness: 0.5,
                                                                color: theme
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  4.0,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    ListView
                                                                        .separated(
                                                                      primary:
                                                                          false,
                                                                      separatorBuilder:
                                                                          (context, index) =>
                                                                              Divider(
                                                                        height:
                                                                            12,
                                                                        thickness:
                                                                            0.5,
                                                                        color: theme
                                                                            .colorScheme
                                                                            .outline,
                                                                      ),
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          orderItemList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              idx) {
                                                                        dynamic
                                                                            orderItem =
                                                                            orderItemList[idx];
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 8.0),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${orderItem['qty']}x",
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 8),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    AutoSizeText(
                                                                                      "${orderItem['remark']}",
                                                                                      style: theme.textTheme.titleMedium,
                                                                                      maxLines: 2, // Allows up to 2 lines
                                                                                      minFontSize: 10,
                                                                                      maxFontSize: 14,
                                                                                      overflow: TextOverflow.ellipsis, // Ellipsis if it exceeds 2 lines
                                                                                    ),
                                                                                    const SizedBox(height: 4),
                                                                                    if ((orderItem.containsKey('note')) && (orderItem['note'] != null) && (orderItem['note'] != ''))
                                                                                      AutoSizeText(
                                                                                        "Notes: ${orderItem['note']}",
                                                                                        style: theme.textTheme.labelSmall,
                                                                                        maxLines: 2,
                                                                                        minFontSize: 10,
                                                                                        maxFontSize: 12,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                (orderItem['docstatus'] == 1)
                                                                                    ? 'Confirm'
                                                                                    : (orderItem['docstatus'] == 2)
                                                                                        ? 'Cancelled'
                                                                                        : 'Draft',
                                                                                style: (orderItem['docstatus'] != 1)
                                                                                    ? TextStyle(
                                                                                        color: () {
                                                                                          if (orderItem['docstatus'] == 1) {
                                                                                            return theme.colorScheme.primary;
                                                                                          } else if (orderItem['docstatus'] == 2) {
                                                                                            return theme.colorScheme.error;
                                                                                          } else {
                                                                                            return theme.colorScheme.onPrimaryContainer;
                                                                                          }
                                                                                        }(),
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 12,
                                                                                      )
                                                                                    : TextStyle(
                                                                                        color: theme.colorScheme.primary,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
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
                                            ),
                                          if (servedDisplay.isEmpty)
                                            EmptyData(),
                                        ],
                                      ),
                                    ),
                                    // ),
                                  ),
                                ),
                              ),
                            if (isLoadingContent)
                              const Align(
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: LoadingContent(),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.25,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              border: Border(
                                left: BorderSide(
                                  color: theme.colorScheme.outline,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      onTapCustomer(context);
                                    },
                                    child: SizedBox(
                                      height: 48,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Icon(
                                              (AppState().customerSelected ==
                                                      null)
                                                  ? Icons.person_search_outlined
                                                  : Icons.person_outlined,
                                              color:
                                                  theme.colorScheme.secondary,
                                              size: 24.0,
                                            ),
                                          ),
                                          if (customerSelected == null)
                                            Text(
                                              'Customer',
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                              ),
                                            ),
                                          if (customerSelected != null)
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        2.0, 18.0, 2.0, 2.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      customerSelected[
                                                          'customer_name'],
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: theme.colorScheme
                                                            .primary,
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
                                if ((customerSelected != null))
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      onTapRemoveCustomer(context);
                                    },
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.06,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: theme.colorScheme.secondary,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    onTapCreateCustomer(context);
                                  },
                                  child: Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.06,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: theme.colorScheme.outline,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 0.0),
                                      child: Icon(
                                        Icons.person_add,
                                        color: (AppState().customerSelected ==
                                                false)
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.secondary,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1.0,
                            thickness: 0.5,
                            color: theme.colorScheme.outline,
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.25,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          onTapTypeTransaction(context);
                                        },
                                        child: Container(
                                          height: 48.0,
                                          decoration: BoxDecoration(
                                            color: theme
                                                .colorScheme.primaryContainer,
                                            border: Border(
                                              bottom: BorderSide(
                                                color:
                                                    theme.colorScheme.outline,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (typeTransaction == '')
                                                  Text(
                                                    'Pilih Jenis Transaksi',
                                                    style: theme
                                                        .textTheme.labelMedium,
                                                  ),
                                                if (typeTransaction != '')
                                                  Text(
                                                    typeTransaction,
                                                    style: theme
                                                        .textTheme.titleSmall,
                                                  ),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        onTapTableNumber(context);
                                      },
                                      child: Container(
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: theme.colorScheme.outline,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (tableNumber == '')
                                                Text(
                                                  'Pilih Nomor Meja',
                                                  style: theme
                                                      .textTheme.labelMedium,
                                                ),
                                              if (tableNumber != '')
                                                Text(
                                                  tableNumber,
                                                  style: theme
                                                      .textTheme.titleSmall,
                                                ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    theme.colorScheme.secondary,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (cartData.isNotEmpty) {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            barrierColor:
                                                const Color(0x80000000),
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: DialogCustomWidget(
                                                    description:
                                                        'Are you sure to reset cart?',
                                                    isConfirm: true,
                                                    captionConfirm: 'Reset',
                                                    styleConfirm: TextStyle(
                                                      color: theme
                                                          .colorScheme.error,
                                                    ),
                                                    onConfirm: () {
                                                      cart.clearCart();
                                                      setState(() {
                                                        AppState
                                                            .resetOrderCart();
                                                        cartData = [];
                                                        cartSelected = null;

                                                        // modeView == 'order';
                                                      });
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          border: Border(
                                            left: BorderSide(
                                              color: theme.colorScheme.outline,
                                              width: 0.6,
                                            ),
                                            bottom: BorderSide(
                                              color: theme.colorScheme.outline,
                                              width: 0.6,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                          child: Icon(
                                            Icons.delete_forever_outlined,
                                            color: cartData.isNotEmpty
                                                ? theme.colorScheme.onError
                                                : theme.colorScheme.outline,
                                            size: 30.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.25,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (cartSelected != null)
                                    Container(
                                      width: double.infinity,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.outline,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 4.0, 0.0, 4.0),
                                        child: Text(
                                          cartSelected['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (cartData.isNotEmpty)
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            child: Builder(
                                              builder: (context) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: cartData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final itemData =
                                                        cartData[index];
                                                    bool isCheck =
                                                        itemData.status
                                                            ? true
                                                            : false;
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(8.0,
                                                              4.0, 8.0, 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${itemData.qty}x ${itemData.itemName}',
                                                                style: CustomTextStyles
                                                                    .labelLargeBlack,
                                                              ),
                                                              if (((modeView ==
                                                                          'confirm') ||
                                                                      ((modeView ==
                                                                          'served'))) &&
                                                                  (itemData
                                                                          .docstatus ==
                                                                      0))
                                                                Checkbox(
                                                                  value:
                                                                      isCheck,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    if (value !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        isCheck =
                                                                            value;
                                                                      });
                                                                      onCheckboxChange(
                                                                        itemData,
                                                                        index,
                                                                        value,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              if ((itemData
                                                                      .docstatus ==
                                                                  2))
                                                                Text(
                                                                  'Cancelled',
                                                                  style:
                                                                      TextStyle(
                                                                    color: theme
                                                                        .colorScheme
                                                                        .error,
                                                                  ),
                                                                )
                                                            ],
                                                          ),
                                                          // Dotted Divider Line
                                                          StyledDivider(
                                                            height: 15.0,
                                                            thickness: 2.0,
                                                            color: theme
                                                                .colorScheme
                                                                .outline,
                                                            lineStyle:
                                                                DividerLineStyle
                                                                    .dotted,
                                                          ),
                                                          Text(
                                                            '${itemData.qty} x Rp ${numberFormat('idr_fixed', itemData.price)}',
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .secondary,
                                                            ),
                                                          ),
                                                          if ((itemData.notes !=
                                                                  null) &&
                                                              (itemData.notes !=
                                                                  ''))
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4.0),
                                                              child: Text(
                                                                'Notes: ${itemData.notes}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: theme
                                                                      .colorScheme
                                                                      .secondary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          const SizedBox(
                                                              height: 8),
                                                          if ((itemData
                                                                  .docstatus !=
                                                              2))
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if ((itemData
                                                                            .docstatus ==
                                                                        0) &&
                                                                    (modeView ==
                                                                        'order'))
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            onTapEditItem(
                                                                              context,
                                                                              itemData,
                                                                              index,
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                8.0,
                                                                                8.0,
                                                                                8.0),
                                                                            child:
                                                                                Text(
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
                                                                if ((itemData
                                                                            .docstatus !=
                                                                        2) &&
                                                                    (modeView !=
                                                                        'served'))
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (itemData.id.contains(itemData.itemName)) {
                                                                              onTapDelete(
                                                                                context,
                                                                                itemData,
                                                                                index,
                                                                              );
                                                                            } else {
                                                                              onTapCancel(
                                                                                context,
                                                                                itemData,
                                                                                index,
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                8.0,
                                                                                8.0,
                                                                                8.0,
                                                                                8.0),
                                                                            child:
                                                                                Text(
                                                                              itemData.id.contains(itemData.itemName) ? 'Delete' : 'Cancel',
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    6.0,
                                                                    8.0,
                                                                    0.0),
                                                            child: Divider(
                                                              height: 5.0,
                                                              thickness: 0.5,
                                                              color: theme
                                                                  .colorScheme
                                                                  .outline,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ))),
                                  if ((cartSelected != null) &&
                                      (cartData.isNotEmpty))
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 8.0, 0.0, 8.0),
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
                                  if (cartData.isEmpty) EmptyCart()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 51.0,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: BottomNavigationOrder(
                isSelected: modeView,
                onTapMenu: () {
                  setState(() {
                    modeView = 'order';
                  });
                  // Navigator.pushNamed(context, AppRoutes.orderScreen);
                },
                onTapOrderToConfirm: () {
                  setState(() {
                    modeView = 'confirm';
                    cartSelected = null;
                    cart.clearCart();
                    cartData = cart.getAllItemCart();
                  });
                  onTapRefreshOrder();
                  // Navigator.pushNamed(context, AppRoutes.confirmScreen);
                },
                onTapOrderToServed: () {
                  setState(() {
                    modeView = 'served';
                    cartSelected = null;
                    cart.clearCart();
                    cartData = cart.getAllItemCart();
                    //stopAudio();
                  });
                  onTapRefreshHistory();
                  // Navigator.pushNamed(context, AppRoutes.servescreen);
                },
                onTapAction: () {
                  if (cartData.isNotEmpty) {
                    onTapAction(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool? onSearchFilterMenu(String value, String search) {
    return value.toLowerCase().contains(search.toLowerCase());
  }

  List<dynamic> menu(List<dynamic> data, String search, String filter) {
    // itemDisplay = AppState().dataItem;
    return data
        .where((item) => (item['item_name']
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase()) &&
            item['item_group']
                .toString()
                .toLowerCase()
                .contains(filter.toLowerCase())))
        .toList();
  }

  List<dynamic> order(List<dynamic> data, String search) {
    return data
        .where((item) => item['name']
            .toString()
            .toLowerCase()
            .contains(search.toLowerCase()))
        .toList();
  }

  onTapRefreshHistory() async {
    setState(() {
      isLoadingContent = true;
      servedDisplay.clear();
    });
    await onCallDataPosCart();
    await onCallDataPosDelivery();
    await reformatServedCart();

    //('check servedDisplay, ${servedDisplay}');
  }

  onTapRefreshMenu() async {
    setState(() {
      isLoadingContent = true;
    });
    // await onCallItemGroup();
    await onCallItemPrice();
    await onCallItem();
  }

  onTapRefreshOrder() async {
    setState(() {
      isLoadingContent = true;
    });
    await onCallDataPosCart();
    await onCallDataPosOrder();
    await reformatOrderCart();
  }

  onTapAction(BuildContext context) async {
    if (modeView == 'order') {
      if (cartSelected == null) {
        await onCallCreatePosCart();
        setState(() {
          cartSelected = null;
          AppState.resetOrderCart();
          cartData = [];
          // print('set state');
        });
      } else {
        for (OrderCartItem itm in cartData) {
          dynamic itemReq = {};
          if (itm.id.contains(itm.itemName)) {
            itemReq = {
              'name': itm.name,
              'item_name': itm.itemName,
              'item_group': itm.itemGroup,
              'uom': itm.uom,
              'qty': itm.qty,
              'notes': itm.notes,
            };
          } else {
            itemReq = {
              'id': itm.id,
              'name': itm.name,
              'item_name': itm.itemName,
              'item_group': itm.itemGroup,
              'uom': itm.uom,
              'qty': itm.qty,
              'notes': itm.notes,
            };
          }
          // onCallPosOrder(itemReq);
          if ((itm.docstatus != 1) && (itm.docstatus != 2)) {
            await onCallCreatePosOrder(itemReq);
          }
        }
        setState(() {
          cartSelected = null;
          AppState.resetOrderCart();
          cartData = [];
          // print('set state');
        });
      }
      await onTapRefreshOrder();
    } else if (modeView == 'confirm') {
      bool printChecker = false;
      if (cartSelected != null) {
        for (OrderCartItem itm in cartData) {
          dynamic itemReq = {
            'id': itm.id,
            'name': itm.name,
            'item_name': itm.itemName,
            'item_group': itm.itemGroup,
            'uom': itm.uom,
            'qty': itm.qty,
            'notes': itm.notes,
            'status': itm.status,
          };
          // onCallPosOrder(itemReq);
          if (itm.docstatus != 2) {
            if (itm.status == true) {
              print('order submmit');
              await onCallSubmitPosOrder(itemReq);
              printChecker = true;
            } else {
              print('order udpate');
              await onCallCreatePosOrder(itemReq);
            }
          }
        }
        if (printChecker == true) {
          onPrintChecker(false);
        }
        setState(() {
          AppState.resetOrderCart();
          cartData = [];
          modeView = 'confirm';
          cartSelected = null;
        });
        await onTapRefreshOrder();
      }
    } else if (modeView == 'served') {
      if (cartSelected != null) {
        for (OrderCartItem itm in cartData) {
          dynamic itemReq = {
            'id': itm.id,
            'name': itm.name,
            'item_name': itm.itemName,
            'item_group': itm.itemGroup,
            'uom': itm.uom,
            'qty': itm.qty,
            'notes': itm.notes,
            'status': itm.status,
          };
          // onCallPosOrder(itemReq);
          if (itm.docstatus == 0) {
            await onCallSubmitPosDelivery(itemReq);
          }
        }
        setState(() {
          AppState.resetOrderCart();
          cartData = [];
          modeView = 'served';
          cartSelected = null;
        });
        await onTapRefreshHistory();
      }
    }
  }

  onTapActionServe(BuildContext context, dynamic item) async {
    //print('serve selected, $item');
    setState(() {
      // invoiceSelected = item;
      isLoadingDetail = true;
    });
    await onCallDataPosInvoiceDetail(item);
    setState(() {});
  }

  onCallDataPosInvoiceDetail(dynamic invoice) async {
    final FrappeFetchDataGetInvoice.PosInvoiceRequest reqPosInvoiceDetail =
        FrappeFetchDataGetInvoice.PosInvoiceRequest(
            cookie: AppState().cookieData, id: invoice['name']);

    try {
      final request = await FrappeFetchDataGetInvoice.requestDetail(
          requestQuery: reqPosInvoiceDetail);

      if (request.isNotEmpty) {
        setState(() {
          servesSelected = request;
          isLoading = false;
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
      // isLoading = false;
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

  onTapDelete(BuildContext context, dynamic item, int index) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x80000000),
      context: context,
      builder: (context) {
        return GestureDetector(
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: DialogCustomWidget(
              description: 'Are you sure to delete item?',
              isConfirm: true,
              captionConfirm: 'Delete',
              styleConfirm: TextStyle(
                color: theme.colorScheme.error,
              ),
              onConfirm: () async {
                cart.removeItem(item.id);
              },
            ),
          ),
        );
      },
    );
    setState(() {
      // cartData = cart.getAllItemCart();
    });
  }

  onTapCancel(BuildContext context, dynamic item, int index) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x80000000),
      context: context,
      builder: (context) {
        return GestureDetector(
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: DialogCustomWidget(
              description: 'Are you sure to cancel item?',
              isConfirm: true,
              captionConfirm: 'Cancel',
              styleConfirm: TextStyle(
                color: theme.colorScheme.error,
              ),
              onConfirm: () async {
                dynamic itemReq = {
                  'id': item.id,
                  'name': item.name,
                  'item_name': item.itemName,
                  'item_group': item.itemGroup,
                  'uom': item.uom,
                  'qty': item.qty,
                  'notes': item.notes,
                  'status': item.status,
                  'docstatus': item.docstatus,
                };

                if (item.docstatus == 0) {
                  await onCallDeletePosOrder(itemReq);
                } else {
                  await onCallCancelPosOrder(itemReq);
                }

                setState(() {
                  AppState.resetOrderCart();
                  cartData = [];
                  modeView = 'confirm';
                  cartSelected = null;
                });
                await onTapRefreshOrder();
              },
            ),
          ),
        );
      },
    );

    // setState(() { })
  }

  onCallItemGroup() async {
    // isLoading = true;

    final FrappeFetchDataItemGroup.ItemGroupRequest requestItemGroup =
        FrappeFetchDataItemGroup.ItemGroupRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: '[["company","=","${AppState().configCompany["name"]}"]]',
    );

    try {
      final itemGroupRequest = await FrappeFetchDataItemGroup.requestItemGroup(
              requestQuery: requestItemGroup)
          .timeout(
        const Duration(seconds: 30),
      );

      setState(() {
        AppState().dataItemGroup = itemGroupRequest;
        // itemDisplay = itemGroupRequset;
        // isLoading = false;
      });
    } catch (error) {
      isLoadingContent = false;
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        print(error);
      }
      return;
    }
  }

  onCallItemPrice() async {
    String? today = dateTimeFormat('date', null);
    final FrappeFetchDataItemPrice.ItemPriceRequest requestItemPrice =
        FrappeFetchDataItemPrice.ItemPriceRequest(
      cookie: AppState().cookieData,
      filters: '[["selling","=",1],["valid_from","<=","$today"]]',
      limit: 5000,
    );

    try {
      // Add a timeout of 30 seconds to the profile request
      final itemPriceRequest = await FrappeFetchDataItemPrice.requestItemPrice(
              requestQuery: requestItemPrice)
          .timeout(
        const Duration(seconds: 30),
      );

      // print("item price request: $itemPriceRequest");
      setState(() {
        AppState().dataItemPrice = itemPriceRequest;
        // itemDisplay = reformatItem(itemPriceRequest);
      });
    } catch (error) {
      isLoadingContent = false;
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        print(error);
      }
      return;
    }
  }

  onCallItem() async {
    final FrappeFetchDataItem.ItemRequest requestItem =
        FrappeFetchDataItem.ItemRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters:
          '[["disabled","=",0],["is_sales_item","=",1],["item_group","in",[${filterItemGroupSelected != '' ? '"$filterItemGroupSelected"' : filterItemDefault}]]]',
      // filters: '[["disabled","=",0],["is_sales_item","=",1]]',
      limit: 1500,
    );

    try {
      // Add a timeout of 30 seconds to the profile request
      final itemRequest =
          await FrappeFetchDataItem.requestItem(requestQuery: requestItem)
              .timeout(
        const Duration(seconds: 30),
      );

      // print("titiew: $itemRequest");
      setState(() {
        AppState().dataItem = ReformatItemWithPrice(
          itemRequest,
          AppState().dataItemPrice,
        );
        itemDisplay = AppState().dataItem;
        isLoadingContent = false;
      });
      // AppState().userDetail = profileResult;
    } catch (error) {
      isLoadingContent = false;
      if (error is TimeoutException) {
        // Handle timeout error
        // _bottomScreenTimeout(context);
      } else {
        print(error);
      }
      return;
    }
  }

  List<dynamic> reformatItem(List<dynamic> item) {
    return item.where((itm) => itm['item_group'] != 'Addon').toList();
  }

  onCallDataPosCart({String? id}) async {
    final FrappeFetchDataGetCart.PosCartRequest request =
        FrappeFetchDataGetCart.PosCartRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: id != null
          ? '[["name","=","$id"]]'
          : '[["closed_at","is","not set"]]',
      limit: 1500,
    );

    try {
      final callRequest =
          await FrappeFetchDataGetCart.requestPosCart(requestQuery: request);
      // print('check pos cart, $callRequest');
      if (callRequest.isNotEmpty) {
        setState(() {
          tempPosCart = callRequest;
        });
      }
    } catch (error) {
      print('error call data pos cart, $error');
    }
  }

  onCallDataPosOrder({String? id}) async {
    final FrappeFetchDataGetOrder.PosOrderRequest request =
        FrappeFetchDataGetOrder.PosOrderRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: id != null ? '[["name","=","$id"]]' : '[]',
      limit: 2000,
    );

    try {
      final callRequest =
          await FrappeFetchDataGetOrder.requestPosOrder(requestQuery: request);
      // print('check pos order, $callRequest');
      if (callRequest.isNotEmpty) {
        setState(() {
          tempPosOrder = callRequest;
        });
      }
    } catch (error) {
      print('error call data pos order, $error');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallDataPosDelivery({String? id}) async {
    final FrappeFetchDataGetDelivery.PosDeliveryRequest request =
        FrappeFetchDataGetDelivery.PosDeliveryRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: id != null ? '[["name","=","$id"]]' : '[]',
      limit: 2000,
    );

    try {
      final callRequest =
          await FrappeFetchDataGetDelivery.request(requestQuery: request);
      print('check pos delivery, $callRequest');
      if (callRequest.isNotEmpty) {
        setState(() {
          tempPosServed = callRequest;
        });
        onCheckNewOrder();
        // print('yes');
      }
    } catch (error) {
      print('error call data pos order, $error');
      // if (context.mounted) {
      // ignore: use_build_context_synchronously
      if (mounted) {
        alertError(context, error.toString());
      }
      // }
    }
  }

  onCallDataInvoicePosOrder() async {
    final FrappeFetchDataGetInvoice.PosInvoiceRequest request =
        FrappeFetchDataGetInvoice.PosInvoiceRequest(
      cookie: AppState().cookieData,
      fields: '["*"]',
      filters: '[["pos_profile","=","${AppState().configPosProfile['name']}"]]',
      orderBy: 'posting_date desc',
      limit: 2000,
    );

    try {
      final callRequest =
          await FrappeFetchDataGetInvoice.request(requestQuery: request);

      if (callRequest.isNotEmpty) {
        setState(() {
          tempPosServed = callRequest;
          isLoading = false;
          print('Data received: $tempPosServed');
        });
        // print('check ata, $tempPosOrder');
      }
    } catch (error) {
      print('error call data pos order, $error');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallCreatePosCart() async {
    final FrappeFetchCreateCart.CreatePosCartRequest request =
        FrappeFetchCreateCart.CreatePosCartRequest(
      cookie: AppState().cookieData,
      customer: AppState().customerSelected != null
          ? AppState().customerSelected['name']
          : '0',
      customerName: AppState().customerSelected != null
          ? AppState().customerSelected['customer_name']
          : 'Guest',
      company: AppState().configCompany['name'],
      outlet: AppState().configPosProfile['name'],
      postingDate: dateTimeFormat('date', null).toString(),
      priceList: AppState().configPosProfile['selling_price_list'],
      table: tableNumber,
      id: cartSelected != null ? cartSelected['name'] : null,
    );
    // print('cart selected, $cartSelected');

    // request.getParamID()

    try {
      final callCreatePosCart =
          await FrappeFetchCreateCart.request(requestQuery: request);

      if (callCreatePosCart.isNotEmpty) {
        cartSelected = callCreatePosCart;

        if (cartSelected != null) {
          for (OrderCartItem itm in cartData) {
            // print('cart data, ${itm.qty}');
            dynamic itemReq = {
              'name': itm.name,
              'item_name': itm.itemName,
              'item_group': itm.itemGroup,
              'uom': itm.uom,
              'qty': itm.qty,
              'notes': itm.notes,
            };
            // onCallPosOrder(itemReq);
            onCallCreatePosOrder(itemReq);
          }
        }
      }
    } catch (error) {
      if (context.mounted) {
        print('error pos cart, $error');
        alertError(context, error.toString());
      }
    }
  }

  onCallCreatePosOrder(dynamic paramItem) async {
    final FrappeFetchCreateOrder.CreatePosOrderRequest request =
        FrappeFetchCreateOrder.CreatePosOrderRequest(
      cookie: AppState().cookieData,
      customer: AppState().customerSelected != null
          ? AppState().customerSelected['name']
          : '0',
      customerName: AppState().customerSelected != null
          ? AppState().customerSelected['customer_name']
          : 'Guest',
      company: AppState().configCompany['name'],
      postingDate: dateTimeFormat('date', null).toString(),
      outlet: AppState().configPosProfile['name'],
      priceList: AppState().configPosProfile['selling_price_list'],
      cartNo: cartSelected['name'],
      item: paramItem['name'],
      itemName: paramItem['item_name'],
      itemGroup: paramItem['item_group'],
      uom: paramItem['uom'],
      note: paramItem['notes'] ?? '-',
      qty: paramItem['qty'],
      status: paramItem['status'] == true ? 1 : 0,
      id: paramItem['id'],
    );

    // print('check request, ${request}');
    try {
      final callCreatePosOrder =
          await FrappeFetchCreateOrder.request(requestQuery: request);

      if (callCreatePosOrder.isNotEmpty) {
        // cartSelected = callCreatePosCart;
        if (context.mounted) {
          alertSuccess(context, 'Success, order saved..');
        }
      } else {
        if (context.mounted) {
          alertError(context, 'Gagal mendapatkan balikkan server');
        }
      }
    } catch (error) {
      print('error pos order, $error');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallSubmitPosOrder(dynamic paramItem) async {
    final FrappeFetchSubmitOrder.SubmitPosOrderRequest request =
        FrappeFetchSubmitOrder.SubmitPosOrderRequest(
      cookie: AppState().cookieData,
      // cartNo: cartSelected['name'],
      id: paramItem['id'],
      // status: paramItem['status'] == true ? 1 : 0,
    );

    try {
      final callSubmitPosOrder =
          await FrappeFetchSubmitOrder.request(requestQuery: request);

      if (callSubmitPosOrder.isNotEmpty) {
        if (context.mounted) {
          alertSuccess(context, 'Success, order confirm..');
        }
        setState(() {
          // AppState.resetOrderCart();
          // cartData = [];
          // // modeView = 'item';
          // cartSelected = null;
          // isLoadingContent = true;
        });
        // onTapRefreshOrder();
      }
    } catch (error) {
      print('check error, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallCancelPosOrder(dynamic paramItem) async {
    final FrappeFetchCancelOrder.CancelPosOrderRequest request =
        FrappeFetchCancelOrder.CancelPosOrderRequest(
      cookie: AppState().cookieData,
      cartNo: cartSelected['name'],
      id: paramItem['id'],
      docstatus: paramItem['docstatus'],
    );

    try {
      final callCancelPosOrder =
          await FrappeFetchCancelOrder.request(requestQuery: request);

      if (callCancelPosOrder.isNotEmpty) {
        if (context.mounted) {
          alertSuccess(context, 'Success order cancelled..');
        }
      }
    } catch (error) {
      print('check error, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallDeletePosOrder(dynamic paramItem) async {
    final FrappeFetchDeleteOrder.DeletePosOrderRequest request =
        FrappeFetchDeleteOrder.DeletePosOrderRequest(
      cookie: AppState().cookieData,
      cartNo: cartSelected['name'],
      id: paramItem['id'],
      docstatus: paramItem['docstatus'],
    );

    try {
      final callDeletePosOrder =
          await FrappeFetchDeleteOrder.request(requestQuery: request);

      if (callDeletePosOrder.isNotEmpty) {
        if (context.mounted) {
          alertSuccess(context, 'Success order cancelled..');
        }
      }
    } catch (error) {
      print('check error, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onCallSubmitPosDelivery(dynamic paramItem) async {
    final FrappeFetchSubmitDelivery.SubmitPosServedReq request =
        FrappeFetchSubmitDelivery.SubmitPosServedReq(
      cookie: AppState().cookieData,
      id: paramItem['id'],
    );

    try {
      final callSubmitPosOrder =
          await FrappeFetchSubmitDelivery.request(requestQuery: request);

      if (callSubmitPosOrder.isNotEmpty) {
        if (context.mounted) {
          alertSuccess(context, 'Success, order confirm..');
        }
        setState(() {
          // AppState.resetOrderCart();
          // cartData = [];
          // // modeView = 'item';
          // cartSelected = null;
          // isLoadingContent = true;
        });
        // onTapRefreshHistory();
      }
    } catch (error) {
      print('check error, ${error}');
      if (context.mounted) {
        alertError(context, error.toString());
      }
    }
  }

  reformatOrderCart() async {
    List<dynamic> cartNew = [];

    // print('temp cart, ${tempPosCart[0]}');
    // print('temp order, ${tempPosOrder}');

    if (tempPosCart.isNotEmpty) {
      for (dynamic cartTemp in tempPosCart) {
        dynamic tmp = cartTemp;
        // print('temp order, $tempPosOrder');

        tmp['items'] = tempPosOrder
            .where((ord) => ord['pos_cart'] == tmp['name'])
            .toList();
        cartNew.add(tmp);
      }
    }

    // print('check cart new, $cartNew');
    // print('check cart new, ${cartNew.length}');
    setState(() {
      orderDisplay = cartNew;
      isLoadingContent = false;
    });
    // onTapRefreshOrder();
  }

  reformatServedCart() async {
    List<dynamic> cartNew = [];

    // print('temp cart, ${tempPosCart[0]}');
    print('temp served, ${tempPosServed}');

    if (tempPosCart.isNotEmpty) {
      for (dynamic cartTemp in tempPosCart) {
        dynamic tmp = cartTemp;
        // print('temp order, $tempPosOrder');

        tmp['items'] = tempPosServed
            .where((ord) => ord['pos_cart'] == tmp['name'])
            .toList();
        cartNew.add(tmp);
      }
    }

    print('check cart new, $cartNew');
    // print('check cart new, ${cartNew.length}');
    setState(() {
      servedDisplay = cartNew;
      isLoadingContent = false;
    });
    // onTapRefreshOrder();
  }

  void onTapTypeTransaction(BuildContext context) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return TypeTransaction(
          selected: typeTransaction,
        );
      },
    ).then((value) => {
          setState(() {
            typeTransaction = AppState().typeTransaction;
          }),
          print('check type transaction, $typeTransaction')
        });
  }

  void onTapTableNumber(BuildContext context) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return TableNumber(
          selected: tableNumber,
        );
      },
    ).then(
      (value) => {
        setState(() {
          tableNumber = AppState().tableNumber;
        }),
      },
    );
  }

  onTapCustomer(BuildContext context) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return CustomerList(
          selected: customerSelected,
        );
      },
    ).then(
      (value) => {
        setState(() {
          customerSelected = AppState().customerSelected;
        }),
      },
    );
  }

  onTapRemoveCustomer(BuildContext context) {
    AppState().update(() {
      AppState().customerSelected = null;
    });
    setState(() {
      AppState().customerSelected = null;
      customerSelected = null;
    });
  }

  onTapCreateCustomer(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return CreateCustomerWidget(
            // selected: customerSelected,
            );
      },
    ).then(
      (value) => {
        setState(() {
          customerSelected = AppState().customerSelected;
        }),
      },
    );
  }

  void onTapOpenItem(BuildContext context, dynamic item) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          // child: ItemDetailsDialog(
          //   name: item['nama_menu'],
          //   price: int.parse(item['harga'].toString()),
          //   idMenu: item['id_menu'],
          //   type: item['type'],
          //   onAddToCart: (item) {},
          // ),
          // child: Container(),
          child: AddToCart(
            dataMenu: item,
            order: true,
          ),
        );
      },
    ).then((value) => {});
    setState(() {
      // Map<String, dynamic> recap = cart.recapCart();
      // AppState().totalPrice = double.parse(recap['totalPrice']);
      // print('test, ${(cart.recapCart()).totalPrice}');

      cartData = cart.getAllItemCart();
      // print('check cart data, ${cartData}');
    });
  }

  void onTapEditItem(BuildContext context, dynamic item, int index) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        dynamic editItem = {
          'id': item.id,
          'item_name': item.itemName,
          'notes': item.notes,
          'name': item.name,
          'qty': item.qty,
          'price': item.price,
          'uom': item.uom,
          'item_group': item.itemGroup,

          // 'variantPrice': item.variantPrice,
          // 'totalPrice': item.totalPrice,
          // 'addonsPrice': item.addonsPrice,
        };

        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: AddToCart(
            dataMenu: editItem,
            idxMenu: index,
            order: true,
          ),
        );
      },
    ).then((value) => {});
    setState(() {
      cartData = cart.getAllItemCart();
    });
  }

  void addToCartFromOrder(BuildContext context, dynamic order) async {
    setState(() {
      cart.clearCart();
      AppState.resetOrderCart();
      AppState().customerSelected = null;
      customerSelected = null;
    });
    const Duration(seconds: 1);

    for (int a = 0; a < order['items'].length; a++) {
      OrderCartItem newItem = OrderCartItem(
        id: order['items'][a]['name'],
        name: order['items'][a]['item'],
        itemName: order['items'][a]['item_name'],
        itemGroup: order['items'][a]['item_group'],
        uom: order['items'][a]['uom'] ?? '',
        description: order['items'][a]['description'] ?? '',
        qty: order['items'][a]['qty'],
        price: order['items'][a]['price'] != null
            ? order['items'][a]['price'].floor()
            : 0,
        notes: modeView == "served"
            ? order['items'][a]['remark']
            : order['items'][a]['note'],
        preference: order['items'][a]['preference'] ?? {},
        status: order['items'][a]['docstatus'] == 1 ? true : false,
        docstatus: order['items'][a]['docstatus'],
        addon: [],
        totalAddon: 0,
      );

      setState(() {
        cart.addItem(newItem, mode: OrderCartMode.add);
      });
    }
    setState(() {
      enterGuestNameController.text = order['customer_name'].toString();
      customerSelected = {
        'customer_name': order['customer_name'],
        'name': order['customer'],
      };
      typeTransaction = 'dine-in';
      cartData = cart.getAllItemCart();
      cartSelected = order;
      tableNumber = order['table'];
    });
  }

  onCheckboxChange(OrderCartItem itemOrder, int? index, bool? value) {
    // print('chekc item order, $itemOrder');
    // print('test--- 1, ${tempPosOrder}');
    // print('test--- 2, ${tempPosCart}');
    OrderCartItem itemNew = cart.getItemByIndex(index!);
    // itemNew.status = value;
    // print('check item --- 3, ${itemNew.id}');
    OrderCartItem newItem = OrderCartItem(
      id: itemNew.id,
      name: itemNew.name,
      itemName: itemNew.itemName,
      itemGroup: itemNew.itemGroup,
      uom: itemNew.uom,
      description: itemNew.description,
      qty: itemNew.qty,
      price: itemNew.price,
      notes: itemNew.notes,
      preference: itemNew.preference,
      status: value ?? false,
      docstatus: itemNew.docstatus,
      addon: itemNew.addon,
      totalAddon: itemNew.totalAddon,
    );
    // print('check itemNew, ${itemNew['status']}');
    setState(() {
      //   itemNew['status'] = true;
      cart.addItem(newItem, mode: OrderCartMode.update);
    });
    // print('check cart, ${cartData}');
    // appState.setItemCheckedStatus(
    //   currentOrderId,
    //   listItem.items[i].id,
    //   value ?? false,
    // );
    // _checkAllCheckedStatus();
  }

  onPrintChecker(bool reprint) async {
    dynamic docPrint = await printChecker(
      cartSelected,
      AppState().configPrinter,
      AppState().configApplication,
      reprint ? 'reprint' : null,
    );

    print('print, $docPrint');

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
      if (mounted) {
        alertError(context, error.toString());
      }
    }
  }

  onPrintCheckerBluetooth(bool reprint) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      bool result = false;
      List<int> ticket = await printCheckerBluetooth(
        cartSelected,
        AppState().configPrinter,
        AppState().configApplication,
        reprint ? 'reprint' : null,
      );
      result = await PrintBluetoothThermal.writeBytes(ticket);
      print('result print, $result');
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // final ByteData data = await rootBundle.load('assets/mylogo.jpg');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // img.Image? image = img.decodeImage(bytesImg);

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col5',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'col7',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    return bytes;
  }
  
  // loadAndPlayAudio() async {
  //   final audioSource =
  //       await soLoud.loadAsset('assets/audio/delivery_notif.mp3');
  //   final soundHandle = await soLoud.play(audioSource);
  //   print('Audio played');
  // }

  // void stopAudio() async {
  //   soLoud.stop; // Hentikan semua pemutaran
  // }

  onCheckNewOrder() async {
  const Duration minOrderAge = Duration(minutes: 2);

  if (tempPosServed.isNotEmpty) {
    List<dynamic> temp = tempPosServed;
    temp.sort((a, b) => b['creation'].compareTo(a['creation']));
    final latestOrder = temp.isNotEmpty ? temp.first : null;

    if (latestOrder != null) {
      bool isNewOrder = lastOrderTimestamp == null ||
          DateTime.parse(latestOrder['creation'])
              .isAfter(lastOrderTimestamp!);
      bool isOlderThanMinAge = DateTime.now()
              .difference(DateTime.parse(latestOrder['creation'])) >=
          minOrderAge;

      if (isNewOrder &&
          (latestOrder['docstatus'] == 0) &&
          (isOlderThanMinAge == false)) {
        lastOrderTimestamp = DateTime.parse(latestOrder['creation']);
        onTapRefreshHistory();
        //loadAndPlayAudio();

        // Tambahkan logika untuk mencetak
        try {
          // Pilih metode cetak berdasarkan kebutuhan
          // Menggunakan cetak Bluetooth
          await onPrintCheckerBluetooth(false);

          // Jika ingin menggunakan metode cetak lain, gunakan berikut:
          // await onPrintChecker(false);

          print("Order printed successfully.");
        } catch (error) {
          print("Failed to print the order: $error");
        }
      }
    }
  }
}


      // if (latestOrder != null) {
      //   bool isNewOrder = lastOrderTimestamp == null ||
      //       DateTime.parse(latestOrder['creation'])
      //           .isAfter(lastOrderTimestamp!);

      //   // Cek jika order terbaru dan belum disubmit
      //   if (isNewOrder && latestOrder['docstatus'] == 0) {
      //     lastOrderTimestamp = DateTime.parse(
      //         latestOrder['creation']); // Update timestamp terbaru
      //     loadAndPlayAudio(); // Bunyi notifikasi jika memenuhi syarat
      //     onTapRefreshHistory();
      //   }
      // }
    }

