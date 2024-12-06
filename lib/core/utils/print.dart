import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/core/utils/datetime_ui.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';

Future<dynamic> printInvoice(
  String? type,
  dynamic invoice,
  dynamic configPrinter,
  dynamic configCompany,
  dynamic configPosProfile,
  dynamic configUser,
) async {
  dynamic temp = {};
  List<dynamic> doc = [];

  dynamic dataTemp = {
    'service': invoice['service'] ?? '',
    'creation':
        '${dateTimeFormat('dateui', invoice['posting_date'])} ${timeFormat('time_simple', invoice['posting_time'])}',
    'name': invoice['name'],
    'title': invoice['title'],
    'grand_total': invoice['grand_total'],
    'items': ((invoice['items'] != null)) ? invoice['items'] : [],
    'payments': ((invoice['payments'] != null)) ? invoice['payments'] : [],
    'vouchers': [],
    'change': 0,
    'receipt_no': invoice['name']
  };

  List<dynamic> tempHeader = [];
  List<dynamic> item = [];
  List<dynamic> voucher = [];
  List<dynamic> total = [];
  List<dynamic> payment = [];
  List<dynamic> change = [];
  List<dynamic> footer = [];

  // outlet
  try {
    String outletCode =
        (configPosProfile['name'] != null) ? configPosProfile['name'] : '';
    // String outletLine = (doc['company_address'] != null)
    //     ? doc['company_address']
    //     : '';
    // String outletCity = (dataOutlet['outlet_address_city'] != null)
    //     ? dataOutlet['outlet_address_city']
    //     : '';
    // String outletAddrs = "${outletLine}, ${outletCity}";
    // String outletContact = (dataOutlet['outlet_contact_phone'] != null)
    //     ? dataOutlet['outlet_contact_phone']
    //     : '';
    tempHeader.add({
      "key": "label",
      "style": "large",
      "text": outletCode,
      "type": "center"
    });
    // tempHeader.add({
    //   "key": "label",
    //   "style": "normal",
    //   "text": outletAddrs,
    //   "type": "center"
    // });
    // tempHeader.add({
    //   "key": "label",
    //   "style": "normal",
    //   "text": outletContact,
    //   "type": "center"
    // });
  } catch (e) {
    debugPrint('error outlet, $e');
  }

  // reprint
  try {
    if (invoice['void_at'] == null) {
      if (type == 'reprint') {
        tempHeader.add({
          "key": "label",
          "style": "normal",
          "text": "** Reprinted **",
          "type": "center"
        });
        tempHeader.add({"key": 'line', "type": 'blank'});
      } else if (type == 'bill') {
        tempHeader.add({
          "key": "label",
          "style": "normal",
          "text": "** Bill **",
          "type": "center"
        });
        tempHeader.add({"key": 'line', "type": 'blank'});
      } else {
        tempHeader.add({"key": 'line', "type": 'blank'});
      }
    } else {
      tempHeader.add({
        "key": "label",
        "style": "normal",
        "text": "** Cancelled **",
        "type": "center"
      });
      tempHeader.add({"key": 'line', "type": 'blank'});
    }
  } catch (e) {
    debugPrint('Error reprint, $e');
  }

  String service =
      (dataTemp.containsKey('service') && (dataTemp['service'] != null))
          ? dataTemp['service']
          : '-';

  try {
    tempHeader.add({
      "key": "table",
      "style": "normal",
      "text": ["No", dataTemp['receipt_no']]
    });
    // DateTime parse = DateTime.parse(dataTemp['creation']);
    // String ct = DateFormat('dd-MM-yyyy, HH:mm').format(parse);
    tempHeader.add({
      "key": "table",
      "style": "normal",
      "text": [(service != '') ? service : '-', dataTemp['creation']]
    });

    if ((dataTemp['title'] != null) && (dataTemp['title'] != 'Guest')) {
      // String newCust = (dataTemp['title'], '@');
      tempHeader.add({
        "key": "table",
        "style": "normal",
        "text": ["Customer", dataTemp['title']]
      });
    }

    String ksr = (configUser['name'] != null) ? configUser['name'] : '';
    if (ksr != '') {
      // String newKsr =
      // strGetFirstWord(dataUser['message']['user']['detail']['name'], '@');

      tempHeader.add({
        "key": "table",
        "style": "normal",
        "text": ["Kasir", ksr]
      });
    }
    tempHeader.add({"key": "line", "type": "line"});
  } catch (e) {
    debugPrint('Error header, $e');
  }

  // CART ITEMS
  List<dynamic> tempItem = dataTemp['items'];
  List<dynamic> itemLines = [];
  item = [];

  try {
    for (int i = 0; i < tempItem.length; i++) {
      // if ((tempItem[i].containsKey('parent_addon_idx')) && (tempItem[i]['parent_addon_idx'] == null)) {
      itemLines.add({
        "key": "label",
        "style": "normal",
        "text": tempItem[i]['item_name'],
        "type": "left"
      });
      String qty = numberFormat('number_fixed', tempItem[i]['qty']);
      String rate = numberFormat('idr_fixed', tempItem[i]['rate']);
      String amount = numberFormat('idr_fixed', tempItem[i]['amount']);
      itemLines.add({
        "key": "table",
        "style": "normal",
        "text": [
          "$qty x $rate",
          amount,
        ],
      });

      List<dynamic> tempAddon = ((tempItem[i].containsKey('ui_addon')) &&
              (tempItem[i]['ui_addon'] != null) &&
              (tempItem[i]['ui_addon'].length > 2))
          ? json.decode(tempItem[i]['ui_addon'])
          : [];

      if (tempAddon.isNotEmpty) {
        // item.add({
        //   "key": "label",
        //   "style": "normal",
        //   "type": "left",
        //   "text": "Addon"
        // });

        for (var dtAddon in tempAddon) {
          dynamic qtyA = dtAddon.containsKey('qty')
              ? (dtAddon['qty'] * tempItem[i]['qty'])
              : (1.0 * tempItem[i]['qty']);
          String qtyAddon = numberFormat('number_fixed', qtyA);
          String rateAddon =
              numberFormat('idr_fixed', dtAddon['standard_rate']);
          String amountAddon =
              numberFormat('idr_fixed', (qtyA * dtAddon['standard_rate']));

          itemLines.add({
            "key": "label",
            "style": "normal",
            "text": "(+) ${dtAddon['item_name']}",
            "type": "left"
          });
          itemLines.add({
            "key": "table",
            "style": "normal",
            "text": ["    $qtyAddon x $rateAddon", amountAddon],
          });
          // }
        }
      }
    }
  } catch (e) {
    debugPrint('Error item lines, $e');
  }

  if (itemLines.isNotEmpty) {
    item = [...item, ...itemLines];
  }

  // TOTAL
  total = [];
  try {
    String ttotal = numberFormat('idr_fixed', invoice['total']);
    String discount = numberFormat('idr_fixed', invoice['discount_amount']);
    // String typeDiscount = invoice['additional_discount_percentage'];
    String grandTotal = numberFormat('idr_fixed', invoice['grand_total']);

    total.add({"key": "line", "type": "line"});
    total.add({
      "key": "table",
      "style": "normal",
      "text": ["Total", ttotal]
    });
    total.add({
      "key": "table",
      "style": "normal",
      "text": ["Discount", discount]
    });
    total.add({
      "key": "table",
      "style": "normal",
      "text": ["GRAND TOTAL", grandTotal]
    });
    total.add({"key": "line", "type": "line"});
  } catch (e) {
    debugPrint('Error total, $e');
  }

  // PAYMENT & CHANGE
  List<dynamic> tempPayment = dataTemp['payments'];
  payment = [];
  change = [];

  double nominalChange =
      getChangePayment(dataTemp['payments'], dataTemp['grand_total']);

  try {
    if ((tempPayment.isNotEmpty) && (nominalChange > 0)) {
      for (var dt in tempPayment) {
        payment.add({
          "key": "table",
          "style": "normal",
          "text": [
            dt['mode_of_payment'],
            numberFormat('idr_fixed', (dt['amount'] + dataTemp['change']))
          ]
        });
      }
      change.add({
        "key": "table",
        "style": "normal",
        "text": ['Change', numberFormat('idr_fixed', nominalChange)]
      });
    } else if (tempPayment.isNotEmpty) {
      for (var dt in tempPayment) {
        payment.add({
          "key": "table",
          "style": "normal",
          "text": [
            dt['mode_of_payment'],
            numberFormat('idr_fixed', dt['amount'])
          ]
        });
      }
    }
  } catch (e) {
    debugPrint('Error payments, $e');
  }

  // FOOTER
  try {
    footer = [
      {"key": "line", "type": "blank"},
      {"key": "line", "type": "blank"},
      {
        "key": "label",
        "style": "normal",
        "text": "Thank You",
        "type": "center"
      },
      {"key": "line", "type": "blank"},
      {"key": "line", "type": "line"},
      {"key": "line", "type": "blank"},
      {"key": "cut"}
    ];
    if ((type != 'bill') & (type != 'reprint')) {
      if (tempPayment.isNotEmpty) {
        String getPayment = tempPayment[0]['mode_of_payment'];
        if (getPayment.toLowerCase() == 'cash') {
          footer.add({"key": "openCashDrawer"});
        }
      }
    }
  } catch (e) {
    debugPrint('Error footer, $e');
  }

  if (tempHeader.isNotEmpty) {
    doc = [...doc, ...tempHeader];
  }

  if (item.isNotEmpty) {
    doc = [...doc, ...item];
  }

  // if (voucher.length != 0) {
  //   doc = [...doc, ...voucher];
  // }

  if (total.isNotEmpty) {
    doc = [...doc, ...total];
  }

  if (payment.isNotEmpty) {
    doc = [...doc, ...payment];
  }

  if (change.isNotEmpty) {
    doc = [...doc, ...change];
  }

  if (footer.isNotEmpty) {
    doc = [...doc, ...footer];
  }

  try {
    temp = {
      'printer': configPrinter['selectedPrinter'],
      'width': 80,
      'data': doc,
    };
  } catch (e) {
    debugPrint('Error settingan printer, $e');
  }

  return temp;
}

double getChangePayment(List<dynamic> pay, double total) {
  double totalPay = 0;
  double tmp = 0;
  for (dynamic p in pay) {
    if (p['mode_of_payment'] == 'Cash') {
      totalPay = totalPay + p['amount'];
    }
  }

  if (totalPay > total) {
    tmp = totalPay - total;
  }

  return tmp;
}

dynamic printChecker(
  dynamic dataOrder,
  dynamic configPrinter,
  dynamic configApplication,
  String? type,
) {
  dynamic docToPrint = {};
  List<dynamic> docTemp = [];
  List<dynamic> docHeader = [];
  List<dynamic> docItem = [];
  List<dynamic> tempItem = [];

  // Set header document print
  try {
    // docHeader.add(
    //     {"key": "label", "style": "large", "text": "CHECKER", "type": "left"});

    // docHeader.add({
    //   "key": "table",
    //   "style": "large",
    //   "text": ["CHECKER", dataOrder['service']]
    // });

    if (type == 'reprint') {
      docHeader.add({
        "key": "label",
        "style": "normal",
        "text": "** Reprinted **",
        "type": "center"
      });
      docHeader.add({"key": 'line', "type": 'blank'});
    }

    docHeader.add({"key": "line", "type": "line"});

    docHeader.add({
      "key": "table",
      "style": "normal",
      "text": ["No", dataOrder['name']]
    });

    String docTime = '';

    if ((dataOrder['posting_date'] != null) ||
        (dataOrder['posting_time'] != null)) {
      var tmpDate = dateTimeFormat('dateui', dataOrder['posting_date']);
      var tmpTime = timeFormat('time_simple', dataOrder['posting_time']);
      docTime = '$tmpDate $tmpTime';
    } else if (dataOrder['creation'] != null) {
      docTime = dateTimeFormat('datetime', dataOrder['creation']).toString();
    }

    docHeader.add({
      "key": "table",
      "style": "normal",
      "text": ['Date', docTime]
    });

    if (dataOrder['customer'] != null) {
      String tmpCustomer =
          dataOrder['customer_name'] != '' ? dataOrder['customer_name'] : '';
      docHeader.add({
        "key": "table",
        "style": "normal",
        "text": ['Customer', tmpCustomer]
      });
      docHeader.add({"key": "line", "type": "line"});
    }
  } catch (err) {
    debugPrint('set document print header error , $err');
  }

  if (dataOrder['items'] != null) {
    tempItem = dataOrder['items'];
  } else {
    tempItem = ((dataOrder['items'] != null) && (dataOrder['items'].length > 2))
        ? dataOrder['items']
        : [];
  }

  // Set document items lines
  // Beverage
  print('aoo, ${configApplication}');
  if (tempItem.isNotEmpty) {
    for (var dt in tempItem) {
      if (configApplication['itemGroupSelectedPrint']
          .contains(dt['item_group'])) {
        // if (dt['parent_addon_idx'] == null) {
        String qty = numberFormat('number_fixed', dt['qty']);
        String tmpTitle = '${qty}x  ${dt['item_name']}';
        docItem.add({
          "key": "table",
          "style": "normal",
          "text": [tmpTitle, "[  ]"]
        });

        // check Addon
        List<dynamic> tempAddon =
            ((dt['ui_addon'] != null) && (dt['ui_addon'].length > 2))
                ? json.decode(dt['ui_addon'])
                : [];

        if (tempAddon.isNotEmpty) {
          docItem.add({
            "key": "label",
            "style": "small",
            "type": "left",
            "text": "    Addon"
          });

          tempAddon.asMap().forEach((idx, addon) {
            dynamic qtyA = addon.containsKey('qty') ? (addon['qty']) : (1.0);
            String qtyAddon = numberFormat('number_fixed', qtyA);
            docItem.add({
              "key": "label",
              "style": "normal",
              "type": "left",
              "text": "   + ${qtyAddon}x ${addon['item_name']}"
            });
          });
        }

        if (dt['order_notes'] != null) {
          String notes = '';
          String itemNote = dt['order_notes'];
          if (itemNote.isNotEmpty) {
            List<String> note = [];
            Map tmpNotes = json.decode(dt['order_notes']);
            tmpNotes.forEach((i, nt) {
              if ((nt != null) && (nt != '')) {
                note.add(nt);
              }
            });

            if (note.isNotEmpty) {
              String temNotes = note.join(', ');
              notes = temNotes.substring(0, temNotes.length);
            }

            docItem.add({
              "key": "label",
              "style": "small",
              "type": "left",
              "text": "Note:"
            });

            docItem.add({
              "key": "label",
              "text": notes,
              "style": "normal",
              "type": "left"
            });
          }
        }

        if (dt['notes'] != '' && dt['notes'] != null) {
          docItem.add({
            "key": "label",
            "text": "Note: ${dt['note']}",
            "style": "small",
            "type": "left"
          });
        } else if ((dt['note'] != '') && (dt['note'] != null)) {
          docItem.add({
            "key": "label",
            "text": "Note: ${dt['note']}",
            "style": "small",
            "type": "left"
          });
        }
      }
      // }
    }
  }

  // Food
  // Beverage
  // if (tempItem.length > 0) {
  //   tempItem.forEach((dt) {
  //     if ((dt['item_group'].toLowerCase() == "food")) {
  //       // String qty = dt['requested_qty'].floor().toString();
  //       String qty = dt['qty'].toString();
  //       String tmpTitle = qty + 'x ' + dt['item_name'];
  //       docItem.add({
  //         "key": "table",
  //         "style": "normal",
  //         "text": [tmpTitle, "[  ]"]
  //       });
  //
  //       // check Addon
  //       List<dynamic> tempAddon =
  //           ((dt['ui_addon'] != null) && (dt['ui_addon'].length > 2))
  //               ? json.decode(dt['ui_addon'])
  //               : [];
  //
  //       if (tempAddon.length > 0) {
  //         docItem.add({
  //           "key": "label",
  //           "style": "small",
  //           "type": "left",
  //           "text": "Addon"
  //         });
  //         String tempNameAddon = '';
  //
  //         tempAddon.asMap().forEach((idx, addon) {
  //           tempNameAddon = tempNameAddon +
  //               addon['item_name'] +
  //               ((tempAddon.length - 1) == idx ? ',' : '');
  //         });
  //
  //         docItem.add({
  //           "key": "label",
  //           "style": "small",
  //           "type": "left",
  //           "text": tempNameAddon
  //         });
  //       }
  //     }
  //   });
  // }

  if (docHeader.isNotEmpty) {
    docTemp = [...docTemp, ...docHeader];
  }

  if (docItem.isNotEmpty) {
    docTemp = [...docTemp, ...docItem];
  }

  docTemp.add({"key": "line", "type": "blank"});
  docTemp.add({"key": "cut"});

  try {
    docToPrint = {
      'printer': configPrinter['selectedPrinter'],
      'width': 80,
      'data': docTemp,
    };
  } catch (e) {
    debugPrint('Error settingan printer, $e');
  }

  return docToPrint;
}

Future<List<int>> printCheckerBluetooth(
  dynamic dataOrder,
  dynamic configPrinter,
  dynamic configApplication,
  String? type,
) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> docPrint = [];
  List<dynamic> tempItem = [];

  docPrint += generator.reset();

  if (type == 'reprint') {
    docPrint += generator.text(
      '** Reprinted **',
      styles: const PosStyles(
        align: PosAlign.center,
        // height: PosTextSize.size2,
      ),
    );
    docPrint += generator.emptyLines(1);
  }

  docPrint += generator.hr();
  docPrint += generator.row([
    PosColumn(
      text: 'No',
      width: 6,
      styles: const PosStyles(
        align: PosAlign.left,
        height: PosTextSize.size1,
      ),
    ),
    PosColumn(
      text: dataOrder['name'],
      width: 6,
      styles: const PosStyles(
        align: PosAlign.right,
        height: PosTextSize.size1,
      ),
    ),
  ]);

  String docTime = '';

  if ((dataOrder['posting_date'] != null) ||
      (dataOrder['posting_time'] != null)) {
    var tmpDate = dateTimeFormat('dateui', dataOrder['posting_date']);
    var tmpTime = timeFormat('time_simple', dataOrder['posting_time']);
    docTime = '$tmpDate $tmpTime';
  }

  docPrint += generator.row([
    PosColumn(
      text: 'Date',
      width: 6,
      styles: const PosStyles(
        align: PosAlign.left,
        height: PosTextSize.size1,
      ),
    ),
    PosColumn(
      text: docTime,
      width: 6,
      styles: const PosStyles(
        align: PosAlign.right,
        height: PosTextSize.size1,
      ),
    ),
  ]);

  if (dataOrder['customer'] != null) {
    String tmpCustomer =
        dataOrder['customer_name'] != '' ? dataOrder['customer_name'] : '';
    docPrint += generator.row([
      PosColumn(
        text: 'Customer',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: tmpCustomer,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);
    docPrint += generator.hr();
  }

  if (dataOrder['items'] != null) {
    tempItem = dataOrder['items'];
  } else {
    tempItem = ((dataOrder['items'] != null) && (dataOrder['items'].length > 2))
        ? dataOrder['items']
        : [];
  }

  print('check application, ${tempItem}');

  if (tempItem.isNotEmpty) {
    for (var dt in tempItem) {
      if (configApplication['itemGroupSelectedPrint']
          .contains(dt['item_group'])) {
        String qty = numberFormat('number_fixed', dt['qty']);
        String tmpTitle = '${qty}x  ${dt['item_name']}';

        docPrint += generator.row([
          PosColumn(
            text: tmpTitle,
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
            ),
          ),
          PosColumn(
            text: '[   ]',
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
            ),
          ),
        ]);

        if ((dt['note'] != null) && (dt['note'] != '')) {
          docPrint += generator.text(
            'Note: ${dt["note"]}',
            styles: const PosStyles(align: PosAlign.left),
          );
        }

        if ((dt['remark'] != null) && (dt['remark'] != '')) {
          docPrint += generator.text(
            'Note: ${dt["remark"]}',
            styles: const PosStyles(align: PosAlign.left),
          );
        }
      }
    }
  }

  docPrint += generator.feed(2);
  docPrint += generator.cut();

  return docPrint;
}

Future<List<int>> printInvoiceBluetooth(
  String? type,
  dynamic invoice,
  dynamic configPrinter,
  dynamic configCompany,
  dynamic configPosProfile,
  dynamic configUser,
) async {
  print('check data order, $invoice');
  dynamic dataTemp = {
    'service': invoice['service'] ?? '',
    'creation':
        '${dateTimeFormat('dateui', invoice['posting_date'])} ${timeFormat('time_simple', invoice['posting_time'])}',
    'name': invoice['name'],
    'title': invoice['title'],
    'grand_total': invoice['grand_total'],
    'items': ((invoice['items'] != null)) ? invoice['items'] : [],
    'payments': ((invoice['payments'] != null)) ? invoice['payments'] : [],
    'vouchers': [],
    'change': 0,
    'receipt_no': invoice['name']
  };

  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> docPrint = [];
  // List<dynamic> tempItem = [];

  docPrint += generator.reset();

  // header
  try {
    String outletCode =
        (configPosProfile['name'] != null) ? configPosProfile['name'] : '';
    docPrint += generator.text(
      outletCode,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
      ),
    );
  } catch (e) {
    debugPrint('error outlet, $e');
  }

  try {
    if (invoice['void_at'] == null) {
      if (type == 'reprint') {
        docPrint += generator.text(
          '** Reprinted **',
          styles: const PosStyles(
            align: PosAlign.center,
            // height: PosTextSize.size2,
          ),
        );
        docPrint += generator.emptyLines(1);
      } else if (type == 'bill') {
        docPrint += generator.text(
          '** Bill **',
          styles: const PosStyles(
            align: PosAlign.center,
            // height: PosTextSize.size2,
          ),
        );
        docPrint += generator.emptyLines(1);
      } else {
        docPrint += generator.emptyLines(1);
      }
    } else {
      docPrint += generator.text(
        '** Cancelled **',
        styles: const PosStyles(
          align: PosAlign.center,
          // height: PosTextSize.size2,
        ),
      );
      docPrint += generator.emptyLines(1);
    }
  } catch (e) {
    debugPrint('Error reprint, $e');
  }

  String service =
      (dataTemp.containsKey('service') && (dataTemp['service'] != null))
          ? dataTemp['service']
          : '-';

  try {
    docPrint += generator.row([
      PosColumn(
        text: 'No',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: dataTemp['receipt_no'],
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);

    docPrint += generator.row([
      PosColumn(
        text: (service != '') ? service : '-',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: dataTemp['creation'],
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);

    docPrint += generator.row([
      PosColumn(
        text: 'Customer',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: dataTemp['title'],
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);

    String ksr = (configUser['name'] != null) ? configUser['name'] : '';

    if (ksr != '') {
      docPrint += generator.row([
        PosColumn(
          text: 'Kasir',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: ksr,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
          ),
        ),
      ]);
      docPrint += generator.hr();
    }
  } catch (e) {
    debugPrint('Error header, $e');
  }

  // CART ITEMS
  List<dynamic> tempItem = dataTemp['items'];
  List<dynamic> itemLines = [];
  // item = [];

  try {
    for (int i = 0; i < tempItem.length; i++) {
      docPrint += generator.text(
        tempItem[i]['item_name'],
        styles: const PosStyles(
          align: PosAlign.left,
          // height: PosTextSize.size2,
        ),
      );
      String qty = numberFormat('number_fixed', tempItem[i]['qty']);
      String rate = numberFormat('idr_fixed', tempItem[i]['rate']);
      String amount = numberFormat('idr_fixed', tempItem[i]['amount']);

      docPrint += generator.row([
        PosColumn(
          text: '$qty x $rate',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: amount,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
          ),
        ),
      ]);
    }
  } catch (e) {
    debugPrint('Error Item, $e');
  }

  try {
    // String grandTotal = numberFormat('idr_fixed', dataTemp['grand_total']);
    String ttotal = numberFormat('idr_fixed', invoice['total']);
    String discount = numberFormat('idr_fixed', invoice['discount_amount']);
    // String typeDiscount = invoice['additional_discount_percentage'];
    String grandTotal = numberFormat('idr_fixed', invoice['grand_total']);

    docPrint += generator.hr();
    docPrint += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: ttotal,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);
    docPrint += generator.row([
      PosColumn(
        text: 'Discount',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: discount,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);
    docPrint += generator.row([
      PosColumn(
        text: 'GRAND TOTAL',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: grandTotal,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
        ),
      ),
    ]);
    docPrint += generator.hr();
  } catch (e) {
    debugPrint('Error total, $e');
  }

  // PAYMENT & CHANGE
  List<dynamic> tempPayment = dataTemp['payments'];
  double nominalChange =
      getChangePayment(dataTemp['payments'], dataTemp['grand_total']);

  try {
    if ((tempPayment.isNotEmpty) && (nominalChange > 0)) {
      for (var dt in tempPayment) {
        docPrint += generator.row([
          PosColumn(
            text: dt['mode_of_payment'],
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
            ),
          ),
          PosColumn(
            text:
                numberFormat('idr_fixed', (dt['amount'] + dataTemp['chnage'])),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
            ),
          ),
        ]);
      }
      docPrint += generator.row([
        PosColumn(
          text: 'Change',
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: numberFormat('idr_fixed', nominalChange),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
          ),
        ),
      ]);
      // '0x07'
    } else if (tempPayment.isNotEmpty) {
      for (var dt in tempPayment) {
        docPrint += generator.row([
          PosColumn(
            text: dt['mode_of_payment'],
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
            ),
          ),
          PosColumn(
            text: numberFormat('idr_fixed', dt['amount']),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
            ),
          ),
        ]);
      }
    }
  } catch (e) {
    debugPrint('Error payments, $e');
  }

  try {
    docPrint += generator.emptyLines(2);
    docPrint += generator.text(
      "Thank You",
      styles: const PosStyles(
        align: PosAlign.center,
        // height: PosTextSize.size2,
      ),
    );
    docPrint += generator.emptyLines(1);
    docPrint += generator.hr();
    docPrint += generator.emptyLines(1);

    if ((type != 'bill') & (type != 'reprint')) {
      if (tempPayment.isNotEmpty) {
        String getPayment = tempPayment[0]['mode_of_payment'];
        if (getPayment.toLowerCase() == 'cash') {
          docPrint += generator.drawer();
          // footer.add({"key": "openCashDrawer"});
        }
      }
    }
  } catch (e) {
    debugPrint('Error footer, $e');
  }

  docPrint += generator.feed(1);
  docPrint += generator.cut();

  return docPrint;
}
