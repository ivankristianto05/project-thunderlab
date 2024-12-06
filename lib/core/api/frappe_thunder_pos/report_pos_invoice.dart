import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class ReportPosInvoice {
  final String cookie;
  final String? reportName;
  final String? limitStart;
  final String? orderBy;
  final int? limit;
  final String? filters;
  final String? id;
  // late http.Client client;

  ReportPosInvoice({
    required this.cookie,
    this.reportName,
    this.limit,
    this.limitStart,
    this.filters,
    this.orderBy,
    this.id,
  }) {
    // client = http.Client();
  }

  Map<String, dynamic> formatRequest() {
    Map<String, dynamic> requestMap = {};

    if (reportName != null && reportName!.isNotEmpty) {
      requestMap['report_name'] = reportName;
    }

    // if (limitStart != null && limitStart!.isNotEmpty) {
    //   requestMap['limit_start'] = limitStart;
    // }

    // if (limit != null) {
    //   requestMap['limit'] = limit;
    // }

    if (filters != null && filters!.isNotEmpty) {
      requestMap['filters'] = filters;
    }

    // if (orderBy != null && orderBy!.isNotEmpty) {
    //   requestMap['order_by'] = orderBy;
    // }

    return requestMap;
  }

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  Map<String, String> paramDetail() {
    return {
      'doctype': 'POS Invoice',
      'name': id ?? '',
    };
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

// print('check url, $cookie');
Future<List<dynamic>> request({required ReportPosInvoice requestQuery}) async {
  String url =
      '${AppState().domain}/api/method/frappe.desk.query_report.run?${queryParams(requestQuery.formatRequest())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
  );

  // print('data, ${json.decode(response.body)}');
  print('data, ${json.decode(response.body)}');
  print('url, ${url}');
  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('message')) {
      return responseBody['message']['result'];
    } else {
      throw Exception(responseBody);
    }
  } else {
    throw Exception('System unknown error code ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> requestDetail(
    {required ReportPosInvoice requestQuery}) async {
  String url =
      '${AppState().domain}/api/method/frappe.desk.form.load.getdoc?${queryParams(requestQuery.paramDetail())}';
  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
  );

  print('check param, ${requestQuery.formatHeader()}');

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
