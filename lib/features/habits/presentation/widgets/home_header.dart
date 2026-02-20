import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final int totalHabits;
  final int completedToday;

  const HomeHeader({
    super.key,
    required this.totalHabits,
    required this.completedToday,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 2),
        Text(
          'Seus Hábitos',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        _buildProgressBar(context),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final progress = totalHabits == 0 ? 0.0 : completedToday / totalHabits;
    final isAllDone = totalHabits > 0 && completedToday == totalHabits;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAllDone
            ? AppColors.success.withOpacity(0.08)
            : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAllDone ? 'Tudo feito! 🎉' : 'Progresso de hoje',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isAllDone ? AppColors.success : AppColors.primary,
                ),
              ),
              Text(
                '$completedToday / $totalHabits',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isAllDone ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                isAllDone ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
