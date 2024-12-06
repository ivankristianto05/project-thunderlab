import 'package:flutter/material.dart';
import 'package:kontena_pos/features/authentication/persentation/select_organisation.dart';
import 'package:kontena_pos/features/checkout/persentation/payment_screen.dart';
import 'package:kontena_pos/features/invoices/persentation/history_invoice_screen.dart';
import 'package:kontena_pos/features/invoices/persentation/invoice_screen.dart';
import 'package:kontena_pos/features/orders/persentation/order_screen.dart';
import 'package:kontena_pos/features/authentication/persentation/login_screen.dart';
import 'package:kontena_pos/features/setting/persentation/setting_screen.dart';
// import 'package:kontena_pos/features/orders/persentation/serve_screen.dart';
// import '../features/orders/persentation/confirm_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login';
  static const String selectOrganisationScreen = '/select-organisation';
  static const String orderScreen = '/order';
  static String invoiceScreen = '/invoice';
  static const String historyInvoiceScreen = '/history';
  static const String paymentScreen = '/payment';
  static const String settingScreen = '/setting';
  // static const String confirmScreen = '/confirm';
  // static const String servescreen = '/serve';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => const LoginScreen(),
    selectOrganisationScreen: (context) => const SelectOrganisationScreen(),
    orderScreen: (context) => OrderScreen(),
    invoiceScreen: (context) => InvoiceScreen(),
    historyInvoiceScreen: (context) => const HistoryInvoiceScreen(),
    // confirmScreen: (context) => ConfirmScreen(),
    paymentScreen: (context) => const PaymentScreen(),
    settingScreen: (context) => const SettingScreen(),
    // servescreen: (context) => ServeScreen(),
  };
}
