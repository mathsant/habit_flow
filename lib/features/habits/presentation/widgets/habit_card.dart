import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/habit_with_stats.dart';

class HabitCard extends StatelessWidget {
  final HabitWithStats habitWithStats;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habitWithStats,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final habit = habitWithStats.habit;
    final isCompleted = habitWithStats.isCompletedToday;
    final streak = habitWithStats.currentStreak;
    final color = AppColors.categoryColors[habit.colorIndex];

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: isCompleted ? color.withOpacity(0.4) : AppColors.divider,
                width: isCompleted ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  _buildColorIndicator(color),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildContent(context, streak)),
                  const SizedBox(width: AppSpacing.md),
                  _buildCheckButton(color, isCompleted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorIndicator(Color color) {
    return Container(
      width: 4,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildContent(BuildContext context, int streak) {
    final habit = habitWithStats.habit;
    final isCompleted = habitWithStats.isCompletedToday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habit.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (habit.description != null && habit.description!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            habit.description!,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 6),
        _buildStreakBadge(streak),
      ],
    );
  }

  Widget _buildStreakBadge(int streak) {
    if (streak == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        const Icon(
          Icons.local_fire_department,
          size: 14,
          color: AppColors.streakActive,
        ),
        const SizedBox(width: 4),
        Text(
          '$streak ${streak == 1 ? 'dia' : 'dias'}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.streakActive,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckButton(Color color, bool isCompleted) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted ? color : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? color : AppColors.divider,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 18, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.error),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Excluir hábito'),
        content: Text(
          'Deseja excluir "${habitWithStats.habit.title}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
