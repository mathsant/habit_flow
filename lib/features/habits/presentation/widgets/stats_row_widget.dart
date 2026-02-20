import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/habit_completion.dart';

class StatsRowWidget extends StatelessWidget {
  final List<HabitCompletion> completions;
  final DateTime createdAt;

  const StatsRowWidget({
    super.key,
    required this.completions,
    required this.createdAt,
  });

  int get _totalCompletions => completions.length;

  int get _daysSinceCreation {
    final now = DateTime.now();
    return now.difference(createdAt).inDays + 1;
  }

  double get _completionRate {
    if (_daysSinceCreation == 0) return 0;
    return (_totalCompletions / _daysSinceCreation).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          context,
          label: 'Total',
          value: '$_totalCompletions',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildStatCard(
          context,
          label: 'Dias ativos',
          value: '$_daysSinceCreation',
          icon: Icons.calendar_today_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildStatCard(
          context,
          label: 'Taxa',
          value: '${(_completionRate * 100).toStringAsFixed(0)}%',
          icon: Icons.insights,
          color: AppColors.streakActive,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
