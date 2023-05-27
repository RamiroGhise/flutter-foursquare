


String? formatFoursquareOpenHours(String? hour) {
  String? time = hour;
  if (time != null) {
    if (time.substring(0, 1) == "+") time = time.substring(1);
    String hh = time.substring(0, 2);
    String mm = time.substring(2);

    return '$hh:$mm';
  }

  return null;
}