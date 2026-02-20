import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_flow/core/di/injection_container.dart';
import 'package:habit_flow/core/theme/app_colors.dart';
import 'package:habit_flow/core/theme/app_spacing.dart';
import 'package:habit_flow/core/theme/app_theme.dart';
import 'package:habit_flow/core/widgets/app_button.dart';
import 'package:habit_flow/core/widgets/app_empty_state.dart';
import 'package:habit_flow/core/widgets/app_text_field.dart';
import 'package:habit_flow/features/categories/presentation/cubit/category_cubit.dart';
import 'package:habit_flow/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_flow/features/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CategoryCubit>()..seed()),
        BlocProvider(
          create: (context) => sl<HabitBloc>()..add(LoadHabitsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'HabitFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        home: const SplashPage(),
      ),
    );
  }
}

class DesignPreviewPage extends StatelessWidget {
  const DesignPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HabitFlow')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipografia
            Text(
              'Headline Medium',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Title Medium',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
            Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),

            // Cores das categorias
            Text(
              'Cores de Categorias',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              children: AppColors.categoryColors
                  .map((c) => CircleAvatar(backgroundColor: c, radius: 18))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Botões
            Text('Botões', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Criar Hábito', onPressed: () {}),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Cancelar', onPressed: () {}, isOutlined: true),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Carregando', onPressed: () {}, isLoading: true),
            const SizedBox(height: AppSpacing.lg),

            // TextField
            Text('Input', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const AppTextField(
              label: 'Nome do hábito',
              hint: 'Ex: Meditar por 10 minutos',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Empty State
            Text('Empty State', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const AppEmptyState(
              icon: Icons.self_improvement,
              title: 'Nenhum hábito ainda',
              subtitle: 'Crie seu primeiro hábito e comece sua jornada!',
              buttonLabel: 'Criar hábito',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
