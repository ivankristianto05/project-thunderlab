import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class EntryClosing {
  final String cookie;
  final String periodStart;
  final String periodEnd;
  final String postingDate;
  final String posOpeningId;
  final String company;
  final String posProfile;
  final String user;

  EntryClosing({
    required this.cookie,
    required this.periodStart,
    required this.periodEnd,
    required this.postingDate,
    required this.posOpeningId,
    required this.company,
    required this.posProfile,
    required this.user,
  });

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
      'accept': 'application/json',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
  }

  Map<String, dynamic> toJson() {
    final data = {
      // "docstatus": 1,
      "start": periodStart,
      "end": periodEnd,
      // "posting_date": postingDate,
      "pos_profile": posProfile,
      "user": user,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  String toJsonString() {
    // Convert the map to JSON string
    return json.encode(toJson());
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<List<dynamic>> request({required EntryClosing requestQuery}) async {
  String url =
      '${AppState().domain}/api/method/erpnext.accounts.doctype.pos_closing_entry.pos_closing_entry.get_pos_invoices';

  final response = await http.post(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: queryParams(requestQuery.toJson()),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (responseBody.containsKey('message')) {
      return responseBody['message'];
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
