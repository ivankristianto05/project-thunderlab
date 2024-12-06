import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

// login
class loginRequest {
  final String username;
  final String password;

  loginRequest({
    required this.password,
    required this.username,
  });

  Map<String, String> formatHeaders() {
    return {
      // 'Content-Type': 'application/json',
      'thunderapp': 'JC-CORP-3.0.0',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': '*',
    };
  }

  Map<String, dynamic> formatLoginRequest() {
    return {
      'usr': username,
      'pwd': password,
    };
  }
}

Future<Map<String, dynamic>> login(loginRequest requestBody) async {
  final response = await http.post(
    Uri.parse('${AppState().domain}/api/method/login'),
    headers: requestBody.formatHeaders(),
    body: requestBody.formatLoginRequest(),
  );
  if (response.statusCode == 200) {
    // print('check respon, ${response.headersSplitValues}');
    final responseBody = json.decode(response.body);
    // print('check respon, ${responseBody['message']}');

    if (responseBody.containsKey('message')) {
      if (responseBody['message'] == 'Logged In') {
        String? setCookie = response.headers['set-cookie'];
        AppState().cookieData = setCookie ?? '';
        return responseBody;
      } else {
        throw Exception(responseBody['message']['message']);
      }
    } else {
      throw Exception(responseBody['message']);
    }
  } else {
    throw Exception('System unknown error code ${response.statusCode}');
  }
}
// logout
// forgot password
// reset password