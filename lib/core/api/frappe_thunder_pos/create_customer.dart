import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class CreateCustomer {
  final String cookie;
  final String customerName;
  final String customerType;
  final String customerGroup;
  final String territory;
  final String? id;

  CreateCustomer({
    required this.cookie,
    required this.customerType,
    required this.customerName,
    required this.customerGroup,
    required this.territory,
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
      "docstatus": 1,
      "customer_name": customerName,
      "customer_type": customerType,
      "customer_group": customerGroup,
      "territory": territory,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required CreateCustomer requestQuery}) async {
  String url;

  if (requestQuery.getParamID() != null) {
    url =
        '${AppState().domain}/api/resource/Customer/${requestQuery.getParamID()}';
  } else {
    url = '${AppState().domain}/api/resource/Customer';
  }

  final response = await http.post(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );

  print('ctest, ${response.body}');
  print('ctest, ${requestQuery.toJson()}');

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (requestQuery.getParamID() != null) {
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
