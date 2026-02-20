import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../categories/domain/utils/category_icon_helper.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/habit_with_stats.dart';
import '../bloc/habit_bloc.dart';
import '../widgets/stats_row_widget.dart';
import '../widgets/streak_widget.dart';
import '../widgets/weekly_grid_widget.dart';
import 'create_habit_page.dart';

class HabitDetailPage extends StatelessWidget {
  final HabitWithStats habitWithStats;

  const HabitDetailPage({super.key, required this.habitWithStats});
  @override
  Widget build(BuildContext context) {
    final habit = habitWithStats.habit;
    final color = AppColors.categoryColors[habit.colorIndex];

    return BlocConsumer<HabitBloc, HabitState>(
      listener: (context, state) {
        if (state is HabitError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final currentStats = state is HabitLoaded
            ? state.habits.firstWhere(
                (h) => h.habit.id == habit.id,
                orElse: () => habitWithStats,
              )
            : habitWithStats;

        final isCompleted = currentStats.isCompletedToday;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, currentStats, color),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        StreakWidget(
                          currentStreak: currentStats.currentStreak,
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        WeeklyGridWidget(
                          completions: currentStats.completions.where((c) {
                            final sevenDaysAgo = DateTime.now().subtract(
                              const Duration(days: 7),
                            );
                            return c.completedAt.isAfter(sevenDaysAgo);
                          }).toList(),
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // ─── Gráfico novo ───────────────────────
                        WeeklyGridWidget(
                          completions: currentStats.completions.where((c) {
                            final sevenDaysAgo = DateTime.now().subtract(
                              const Duration(days: 7),
                            );
                            return c.completedAt.isAfter(sevenDaysAgo);
                          }).toList(),
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // ────────────────────────────────────────
                        Text(
                          'Estatísticas',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        StatsRowWidget(
                          completions: currentStats.completions,
                          createdAt: habit.createdAt,
                        ),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),

              // Botão fixo no rodapé
              Positioned(
                bottom: 24,
                left: AppSpacing.pagePadding,
                right: AppSpacing.pagePadding,
                child: GestureDetector(
                  onTap: () {
                    context.read<HabitBloc>().add(
                      ToggleCompletionEvent(currentStats.habit.id),
                    );
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : color,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.buttonRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isCompleted ? AppColors.success : color)
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCompleted ? 'Concluído hoje!' : 'Marcar como feito',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    HabitWithStats stats,
    Color color,
  ) {
    final habit = stats.habit;
    final categoryState = context.read<CategoryCubit>().state;
    String categoryName = '';
    String categoryIcon = 'star';

    if (categoryState is CategoryLoaded) {
      try {
        final category = categoryState.categories.firstWhere(
          (c) => c.id == habit.categoryId,
        );
        categoryName = category.name;
        categoryIcon = category.icon;
      } catch (_) {}
    }

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: color,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateHabitPage(habitWithStats: stats),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            80,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    CategoryIconHelper.getIcon(categoryIcon),
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    categoryName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                habit.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (habit.description != null &&
                  habit.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  habit.description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
