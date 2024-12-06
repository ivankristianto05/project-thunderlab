import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class SubmitPosServedReq {
  final String cookie;
  final String? id;

  SubmitPosServedReq({
    required this.cookie,
    this.id,
  });

  Map<String, String> formatHeader() {
    return {'Cookie': cookie};
  }

  String? getParamID() {
    return id;
  }

  Map<String, dynamic> toJson() {
    final data = {"docstatus": 1};

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required SubmitPosServedReq requestQuery}) async {
  String url;

  if (requestQuery.getParamID() != null) {
    url =
        '${AppState().domain}/api/resource/POS Delivery/${requestQuery.getParamID()}';
  } else {
    url = '${AppState().domain}/api/resource/POS Delivery';
  }

  print('url, $url');
  print('body, ${json.encode(requestQuery.toJson())}');

  final response = await http.put(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );

  print('response code, ${response.statusCode}');
  print('respon body, ${response.body}');

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
