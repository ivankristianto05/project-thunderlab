import 'dart:convert';

import 'package:http/http.dart' as http;

class getPrinter {
  final String url;
  final String ipAddress;

  getPrinter({
    required this.url,
    required this.ipAddress,
  });

  Map<String, dynamic> formatGetPrinter() {
    Map<String, dynamic> requestMap = {};
    return requestMap;
  }

  String queryParams(Map<String, dynamic> map) =>
      map.entries.map((e) => '${e.key}=${e.value}').join('&');
}

Future<Map<String, dynamic>> requestGetPrinter(
    {required getPrinter requestQuery}) async {
  String url = 'http://${requestQuery.ipAddress}:5577/getPrinters';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    // print('check respon, $responseBody');
    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody);
    }
  } else {
    throw Exception('System unknown error code ${response.statusCode}');
  }
}
