import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class StreakWidget extends StatelessWidget {
  final int currentStreak;
  final Color color;

  const StreakWidget({
    super.key,
    required this.currentStreak,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: currentStreak > 0
            ? AppColors.streakActive.withOpacity(0.08)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: currentStreak > 0
              ? AppColors.streakActive.withOpacity(0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: currentStreak > 0
                  ? AppColors.streakActive.withOpacity(0.15)
                  : AppColors.divider.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department,
              color: currentStreak > 0
                  ? AppColors.streakActive
                  : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentStreak == 0
                    ? 'Sem streak'
                    : '$currentStreak ${currentStreak == 1 ? 'dia' : 'dias'} seguidos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: currentStreak > 0
                      ? AppColors.streakActive
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentStreak == 0
                    ? 'Complete hoje para começar!'
                    : 'Continue assim! 🔥',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
