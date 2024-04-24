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
