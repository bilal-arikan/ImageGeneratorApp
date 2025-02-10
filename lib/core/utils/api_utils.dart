class ApiUtils {
  static String buildQueryString(Map<String, dynamic> params) {
    return params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  static DateTime parseDateTime(String date) {
    return DateTime.parse(date).toLocal();
  }

  static String formatDateTime(DateTime date) {
    return date.toUtc().toIso8601String();
  }
}
