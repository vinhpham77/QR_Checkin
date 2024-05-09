import 'dart:convert';

import 'package:intl/intl.dart';

import '../config/user_info.dart';

DateTime? tryParseDateTime(String? formattedString) {
  if (formattedString == null) {
    return null;
  }

  try {
    return DateTime.tryParse(formattedString);
  } on Exception catch (_) {
    return null;
  }
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}g${dateTime.minute}ph';
}

String formatDate(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

String timeLast(DateTime from, DateTime to) {
  if (from.day == to.day && from.month == to.month && from.year == to.year) {
    return '${from.hour}:${from.minute} - ${to.hour}:${to.minute}, ${from.day} tháng ${from.month}, ${from.year}';
  } else {
    return '${from.hour}:${from.minute}, ${from.day} tháng ${from.month}, ${from.year} - ${to.hour}:${to.minute}, ${to.day} tháng ${to.month}, ${to.year}';
  }
}

String decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Chuỗi ký tự base64 không hợp lệ!"');
  }

  return utf8.decode(base64Url.decode(output));
}

void setUserInfo(String jwt) {
  final jwtPayload = jwt.split('.')[1];
  final jwtPayloadString = decodeBase64(jwtPayload);
  final jwtPayloadJson = json.decode(jwtPayloadString);

  UserInfo.username = jwtPayloadJson['sub'];
  UserInfo.role = jwtPayloadJson['role'];
}

String formatPrice(double price) {
  // locale vn
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return formatter.format(price);
}