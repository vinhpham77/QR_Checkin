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
