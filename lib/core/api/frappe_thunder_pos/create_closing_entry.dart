import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class CreateClosingEntry {
  final String cookie;
  final String periodStart;
  final String periodEnd;
  final String postingDate;
  final String posOpeningId;
  final String company;
  final String posProfile;
  final String user;
  final List<dynamic>? posTransaction;
  final List<dynamic>? listPayment;
  final String? id;
  final double? total;

  CreateClosingEntry({
    required this.cookie,
    required this.periodStart,
    required this.periodEnd,
    required this.postingDate,
    required this.posOpeningId,
    required this.company,
    required this.posProfile,
    required this.user,
    this.posTransaction,
    this.listPayment,
    this.id,
    this.total,
  });

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  Map<String, dynamic> toJson() {
    final data = {
      "docstatus": 0,
      "period_start_date": periodStart,
      "period_end_date": periodEnd,
      "posting_date": postingDate,
      "pos_opening_entry": posOpeningId,
      "company": company,
      "pos_profile": posProfile,
      "user": user,
      "pos_transactions": posTransaction,
      "payment_reconciliation": listPayment,
      // "grand_total": total,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  Map<String, dynamic> toJsonSubmit() {
    final data = {
      "docstatus": 1,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  String? getParamID() {
    return id;
  }
}

Future<Map<String, dynamic>> request(
    {required CreateClosingEntry requestQuery}) async {
  String url = '${AppState().domain}/api/resource/POS Closing Entry';

  final response = await http.post(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );
  print('check respon body === ${json.decode(response.body)}');
  print('check query json === ${json.encode(requestQuery.toJson())}');

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        throw Exception(responseBody);
      }
    }
  } else {
    final responseBody = json.decode(response.body);

    throw Exception(responseBody);
  }
}

Future<Map<String, dynamic>> submit(
    {required CreateClosingEntry requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/POS Closing Entry/${requestQuery.getParamID()}';

  final response = await http.put(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJsonSubmit()),
  );

  print('check respon submit body === ${json.decode(response.body)}');
  print('check query submit json === ${json.encode(requestQuery.toJson())}');

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
