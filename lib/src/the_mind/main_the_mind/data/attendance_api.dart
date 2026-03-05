class AttendanceApi {
  Future<List<Map<String, dynamic>>> getLast30Days() async {
    await Future.delayed(const Duration(milliseconds: 600)); // имитация запроса

    // Можешь заменить на реальный вызов http.get(...)
    final fakeJson = List.generate(30, (i) {
      final date = DateTime.now().subtract(Duration(days: 29 - i));
      return {
        "date": date.toIso8601String(),
        "attended": (20 + i * 3) % 100,
        "absent": (10 + i * 2) % 40,
      };
    });

    return fakeJson;
  }
}
