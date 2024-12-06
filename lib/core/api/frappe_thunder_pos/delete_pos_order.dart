import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class DeletePosOrderRequest {
  final String cookie;
  final String cartNo;
  final int docstatus;
  final String id;

  DeletePosOrderRequest({
    required this.cookie,
    required this.docstatus,
    required this.cartNo,
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
      "name": id,
      // "docstatus": 2,
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
    {required DeletePosOrderRequest requestQuery}) async {
  // final getResponse = await http.get(
  //   Uri.parse(
  //       '${AppState().domain}/api/resource/POS Order/${requestQuery.getParamID()}'),
  //   headers: requestQuery.formatHeader(),
  // );

  // final getData = json.decode(getResponse.body);

  // Pastikan 'modified' dari dokumen terbaru
  // final latestModified = getData['data'];
  String url =
      '${AppState().domain}/api/resource/POS Order/${requestQuery.getParamID()}';

  final response = await http.delete(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    // body: json.encode(requestQuery.toJson()),
  );

  // print('body, ${requestQuery.toJson()}');
  // print('body, ${json.encode(latestModified)}');
  print('check status code, ${response.statusCode}');

  if (response.statusCode == 202) {
    final responseBody = json.decode(response.body);
    // print('check responbody, ${responseBody}');
    if (responseBody.containsKey('message')) {
      return responseBody;
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
