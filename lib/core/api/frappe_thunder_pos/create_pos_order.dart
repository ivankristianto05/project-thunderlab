import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class CreatePosOrderRequest {
  final String cookie;
  final String company;
  final String customer;
  final String customerName;
  final String outlet;
  final String postingDate;
  final String priceList;
  final String cartNo;
  final String item;
  final String itemName;
  final String itemGroup;
  final String? uom;
  final String? note;
  final int qty;
  final int status;
  final String? id;

  CreatePosOrderRequest({
    required this.cookie,
    required this.customer,
    required this.customerName,
    required this.company,
    required this.postingDate,
    required this.outlet,
    required this.priceList,
    required this.cartNo,
    required this.item,
    required this.itemName,
    required this.itemGroup,
    this.uom,
    this.note,
    required this.qty,
    required this.status,
    this.id,
  });

  Map<String, String> formatHeader() {
    return {'Cookie': cookie};
  }

  String? getParamID() {
    return id;
  }

  Map<String, dynamic> toJson() {
    final data = {
      // "docstatus": status,
      "customer": customer,
      "customer_name": customerName,
      "company": company,
      "pos_profile": outlet,
      "date": postingDate,
      "pos_cart": cartNo,
      "item": item,
      "item_name": itemName,
      "item_group": itemGroup,
      // "uom": uom,
      "note": note,
      "qty": qty,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required CreatePosOrderRequest requestQuery}) async {
  String url;
  http.Response response;

  if (requestQuery.getParamID() != null) {
    url =
        '${AppState().domain}/api/resource/POS Order/${requestQuery.getParamID()}';
  } else {
    url = '${AppState().domain}/api/resource/POS Order';
  }
  if (requestQuery.getParamID() != null) {
    response = await http.put(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJson()),
    );
  } else {
    response = await http.post(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJson()),
    );
  }

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (requestQuery.getParamID() != null) {
      print('respon data order, ${responseBody}');
      print('respon data order, ${requestQuery.toJson()}');
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        return requestQuery.toJson();
      }
    } else {
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        throw Exception(responseBody);
      }
    }
  } else {
    final responseBody = json.decode(response.body);
    final message;
    if (responseBody.containsKey('exception')) {
      message = responseBody['exception'];
    } else if (responseBody.containsKey('message')) {
      message = responseBody['message'];
    } else {
      message = responseBody;
    }
    throw Exception(message);
  }
}
