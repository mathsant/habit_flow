class StreakCalculator {
  /// Calcula o streak atual (dias consecutivos até hoje)
  static int calculate(List<DateTime> completionDates) {
    if (completionDates.isEmpty) return 0;

    // Normaliza as datas (sem horário) e remove duplicatas
    final dates =
        completionDates
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // mais recente primeiro

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final yesterday = todayNormalized.subtract(const Duration(days: 1));

    // Streak só conta se completou hoje ou ontem
    if (dates.first != todayNormalized && dates.first != yesterday) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      final diff = dates[i].difference(dates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Verifica se o hábito foi completado hoje
  static bool isCompletedToday(List<DateTime> completionDates) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    return completionDates.any((d) {
      final normalized = DateTime(d.year, d.month, d.day);
      return normalized == todayNormalized;
    });
  }
}
