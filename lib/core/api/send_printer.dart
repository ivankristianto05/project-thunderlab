import 'dart:convert';
import 'package:http/http.dart' as http;

class ToPrint {
  final String ipAddress;
  final dynamic doc;
  

  ToPrint({
    required this.ipAddress,
    required this.doc,
  });

  Map<String, String> formatHeader() {
    return {
      'Content-Type': 'application/json',
      'Access-Control_Allow_Origin': '*',
      'Access-Control-Allow-Methods': 'POST',
      'Access-Control-Allow-Headers':
      'Origin, X-Requested-With, Content-Type, Accept',
    };
  }


  Map<String, dynamic> toJson() {
    final data = doc;

    data.removeWhere((key, value) => value == null);
    return data;
  }

  String? ip() {
    return ipAddress;
  }
}

Future<Map<String, dynamic>> request(
    {required ToPrint requestQuery}) async {
  String url = 'http://${requestQuery.ip()}:5577/printPos';

  print('json, ${json.encode(requestQuery.toJson())}');

  final response = await http.post(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
    body: json.encode(requestQuery.toJson()),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);

    if (responseBody.containsKey('status') && (responseBody['status'] == true)) {
      return responseBody;
    } else {
      throw Exception(responseBody);
    }
  } else {
    final responseBody = json.decode(response.body);

    throw Exception(responseBody);
  }
}
