import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_flow/features/habits/presentation/pages/habit_detail_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../bloc/habit_bloc.dart';
import '../widgets/habit_card.dart';
import '../widgets/home_header.dart';
import 'create_habit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HabitBloc, HabitState>(
          listener: (context, state) {
            if (state is HabitError) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HabitLoaded) {
              return _buildContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateHabit(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HabitLoaded state) {
    final habits = state.habits;
    final completedToday = habits.where((h) => h.isCompletedToday).length;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.lg,
            AppSpacing.pagePadding,
            AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: HomeHeader(
              totalHabits: habits.length,
              completedToday: completedToday,
            ),
          ),
        ),
        if (habits.isEmpty)
          SliverFillRemaining(
            child: AppEmptyState(
              icon: Icons.self_improvement,
              title: 'Nenhum hábito ainda',
              subtitle: 'Crie seu primeiro hábito e\ncomece sua jornada!',
              buttonLabel: 'Criar hábito',
              onButtonTap: () => _openCreateHabit(context),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              0,
              AppSpacing.pagePadding,
              100,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habitWithStats = habits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: HabitCard(
                      habitWithStats: habitWithStats,
                      onToggle: () {
                        context.read<HabitBloc>().add(
                          ToggleCompletionEvent(habitWithStats.habit.id),
                        );
                      },
                      onTap: () => _openEditHabit(context, habitWithStats),
                      onDelete: () {
                        context.read<HabitBloc>().add(
                          DeleteHabitEvent(habitWithStats.habit.id),
                        );
                        AppSnackbar.showSuccess(
                          context,
                          'Hábito excluído com sucesso',
                        );
                      },
                    ),
                  );
                },
                childCount: habits.length,
              ),
            ),
          ),
      ],
    );
  }

  void _openCreateHabit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateHabitPage()),
    );
  }

  void _openEditHabit(BuildContext context, habitWithStats) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitDetailPage(habitWithStats: habitWithStats),
      ),
    );
  }
}
