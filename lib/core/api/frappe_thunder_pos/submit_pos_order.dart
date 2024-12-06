import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class SubmitPosOrderRequest {
  final String cookie;
  // final String cartNo;
  // final int status;
  final String id;

  SubmitPosOrderRequest({
    required this.cookie,
    // required this.status,
    // required this.cartNo,
    required this.id,
  });

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
      // 'Content-Type': 'application/x-www-form-urlencoded',
    };
  }

  String? getParamID() {
    return id;
  }

  Map<String, dynamic> toJson() {
    final data = {
      // "doctype": "POS Order",
      "docstatus": 1,
      // "name": id,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  String toJsonString() {
    // Convert the map to JSON string
    return json.encode(toJson());
  }
}

Future<Map<String, dynamic>> request(
    {required SubmitPosOrderRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/POS Order/${requestQuery.getParamID()}';

  final response = await http.put(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody);
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
