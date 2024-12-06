import 'package:intl/intl.dart';

String numberFormat(
  String type,
  dynamic param,
) {
  String result = '';
  if (param.runtimeType == Null) {
    param = 0;
  }

  switch (type) {
    case 'number':
      result = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
          .format(param);
      break;

    case 'money':
      result = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 2)
          .format(param);
      break;

    case 'idr':
      result =
          NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 0)
              .format(param);
      break;

    case 'number_fixed':
      int numberFixed = param.floor();
      result = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
          .format(numberFixed);
      break;

    case 'idr_fixed':
      int numberFixed = param.floor();
      result =
          NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 0)
              .format(numberFixed);
      break;

    case 'number_simple':
      result = simpleFormat(param);
      break;

    case 'idr_simple':
      result = 'IDR ${simpleFormat(param)}';
      break;

    default:
      result = '';
      break;
  }
  return result;
}

String simpleFormat(dynamic param) {
  if (param < 1000) {
    return '$param';
  } else if (param < 1000000) {
    double result = param / 1000.0;
    return '${result.toStringAsFixed(0)}K';
  } else if (param < 1000000000) {
    double result = param / 1000000.0;
    return '${result.toStringAsFixed(0)}M';
  } else if (param < 1000000000000) {
    double result = param / 1000000000.0;
    return '${result.toStringAsFixed(0)}B';
  } else {
    double result = param / 1000000000000.0;
    return '${result.toStringAsFixed(0)}T';
  }
}
