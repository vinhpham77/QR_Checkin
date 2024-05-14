import 'dart:convert';

class QrEvent {
  bool isTicketSeller;
  int eventId;
  bool isCheckin;
  String code;

  QrEvent({
    required this.isTicketSeller,
    this.isCheckin = true,
    required this.eventId,
    required this.code,
  });

  factory QrEvent.fromJson(Map<String, dynamic> json) {
    try {
      return QrEvent(
        isTicketSeller: json['isTicketSeller'],
        isCheckin: json['isCheckin'],
        eventId: json['eventId'],
        code: json['code'],
      );
    } catch (e) {
      throw Exception();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'isTicketSeller': isTicketSeller,
      'isCheckin': isCheckin,
      'eventId': eventId,
      'code': code,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory QrEvent.fromQrCode(String data) {
    Map<String, dynamic> jsonMap = jsonDecode(data);
    try {
      return QrEvent.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Mã QR không hợp lệ');
    }
  }
}