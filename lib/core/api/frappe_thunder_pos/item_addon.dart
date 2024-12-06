import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class ItemAddonRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;
  final String? id;
  // late http.Client client;

  ItemAddonRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
    this.id,
  }) {
    // client = http.Client();
  }

  Map<String, dynamic> formatRequest() {
    Map<String, dynamic> requestMap = {};

    if (fields != null && fields!.isNotEmpty) {
      requestMap['fields'] = fields;
    }

    if (limitStart != null && limitStart!.isNotEmpty) {
      requestMap['limit_start'] = limitStart;
    }

    if (limit != null) {
      requestMap['limit'] = limit;
    }

    if (filters != null && filters!.isNotEmpty) {
      requestMap['filters'] = filters;
    }

    return requestMap;
  }

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  Map<String, String> paramDetail() {
    return {
      'doctype': 'POS Addon',
      'name': id ?? '',
    };
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

// print('check url, $cookie');
Future<List<dynamic>> request({required ItemAddonRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/POS Addon?${queryParams(requestQuery.formatRequest())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
  );
  print('check ${json.decode(response.body)}');
  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody);
    }
  } else {
    throw Exception('System unknown error code ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> requestDetail(
    {required ItemAddonRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/method/frappe.desk.form.load.getdoc?${queryParams(requestQuery.paramDetail())}';
  print('url, $url');
  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('docs')) {
      return responseBody['docs'][0];
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

// void cancelRequest(ItemRequest requestQuery) {
//   requestQuery.client.close();
// }

// Example of using the cancellation function
// void main() async {
//   final requestQuery = ItemRequest(cookie: 'your_token_here');
//   final future = requestItem(requestQuery: requestQuery);

//   // Cancel the request after 5 seconds (as an example)
//   Future.delayed(Duration(seconds: 5), () {
//     cancelRequest(requestQuery);
//   });

//   try {
//     final result = await future;
//     print(result);
//   } catch (e) {
//     print('Error: $e');
//   }
// }
