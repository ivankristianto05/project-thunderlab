import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class CreateOpeningEntry {
  final String cookie;
  final String periodStart;
  final String postingDate;
  final String company;
  final String posProfile;
  final String user;
  final List<dynamic> balance;

  CreateOpeningEntry({
    required this.cookie,
    required this.periodStart,
    required this.postingDate,
    required this.company,
    required this.posProfile,
    required this.user,
    required this.balance,
  });

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  Map<String, dynamic> toJson() {
    final data = {
      "docstatus": 1,
      "period_start_date": periodStart,
      "posting_date": postingDate,
      "company": company,
      "pos_profile": posProfile,
      "user": user,
      'balance_details': balance,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required CreateOpeningEntry requestQuery}) async {
  String url = '${AppState().domain}/api/resource/POS Opening Entry';

  final response = await http.post(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );

  print('check ${json.decode(response.body)}');
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
