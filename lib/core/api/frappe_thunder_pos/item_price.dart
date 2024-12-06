import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_pos/app_state.dart';

class ItemPriceRequest {
  final String cookie;
  final String? fields;
  final String? filters;
  final int? limit;
  final String? orfilters;

  ItemPriceRequest({
    required this.cookie,
    this.fields =
        '["name","item_code", "item_name","price_list_rate","uom","valid_from"]',
    this.limit,
    this.filters,
    this.orfilters,
  });

  Map<String, dynamic> formatRequestItemPrice() {
    Map<String, dynamic> requestMap = {};

    if (fields != null && fields!.isNotEmpty) {
      requestMap['fields'] = fields;
    }

    if (filters != null && filters!.isNotEmpty) {
      requestMap['filters'] = filters;
    }

    if (orfilters != null && orfilters!.isNotEmpty) {
      requestMap['or_filters'] = orfilters;
    }

    if (limit != null) {
      requestMap['limit'] = limit;
    }

    return requestMap;
  }

  Map<String, String> formatHeaderItemPrice() {
    return {
      'Cookie': cookie,
    };
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<List<dynamic>> requestItemPrice(
    {required ItemPriceRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/Item Price?${queryParams(requestQuery.formatRequestItemPrice())}';

  final response = await http.get(Uri.parse(url),
      headers: requestQuery.formatHeaderItemPrice());

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('data')) {
      return responseBody['data'];
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
