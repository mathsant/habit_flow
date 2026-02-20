import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/habit_completion.dart';

class WeeklyGridWidget extends StatelessWidget {
  final List<HabitCompletion> completions;
  final Color color;

  const WeeklyGridWidget({
    super.key,
    required this.completions,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final days = _buildLast7Days();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimos 7 dias',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((day) => _buildDayCell(context, day)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, _DayInfo day) {
    final isToday = day.isToday;

    return Column(
      children: [
        Text(
          day.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: day.isCompleted ? color : AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: isToday
                  ? AppColors.primary
                  : day.isCompleted
                  ? color
                  : AppColors.divider,
              width: isToday ? 2 : 1,
            ),
          ),
          child: day.isCompleted
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          day.dayNumber,
          style: TextStyle(
            fontSize: 11,
            color: isToday ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  List<_DayInfo> _buildLast7Days() {
    final today = DateTime.now();
    final completionDates = completions
        .map(
          (c) => DateTime(
            c.completedAt.year,
            c.completedAt.month,
            c.completedAt.day,
          ),
        )
        .toSet();

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final dateOnly = DateTime(date.year, date.month, date.day);
      final todayOnly = DateTime(today.year, today.month, today.day);

      return _DayInfo(
        label: DateFormat('E', 'pt_BR').format(date).substring(0, 3),
        dayNumber: date.day.toString(),
        isCompleted: completionDates.contains(dateOnly),
        isToday: dateOnly == todayOnly,
      );
    });
  }
}

class _DayInfo {
  final String label;
  final String dayNumber;
  final bool isCompleted;
  final bool isToday;

  const _DayInfo({
    required this.label,
    required this.dayNumber,
    required this.isCompleted,
    required this.isToday,
  });
}
