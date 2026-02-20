import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/habit_completion.dart';

class WeeklyChartWidget extends StatelessWidget {
  final List<HabitCompletion> completions;
  final Color color;

  const WeeklyChartWidget({
    super.key,
    required this.completions,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final data = _buildWeekData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progresso semanal',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.divider),
          ),
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.2,
              minY: 0,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data[value.toInt()].label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: data[value.toInt()].isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: data[value.toInt()].isToday
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.5,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.divider,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final isToday = day.isToday;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: day.isCompleted ? 1.0 : 0.15,
                      color: day.isCompleted ? color : AppColors.divider,
                      width: 28,
                      borderRadius: BorderRadius.circular(8),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 1.2,
                        color: isToday
                            ? AppColors.primary.withOpacity(0.05)
                            : Colors.transparent,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<_DayData> _buildWeekData() {
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

      return _DayData(
        label: DateFormat('E', 'pt_BR').format(date).substring(0, 3),
        isCompleted: completionDates.contains(dateOnly),
        isToday: dateOnly == todayOnly,
      );
    });
  }
}

class _DayData {
  final String label;
  final bool isCompleted;
  final bool isToday;

  const _DayData({
    required this.label,
    required this.isCompleted,
    required this.isToday,
  });
}
