import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_with_stats.dart';
import '../bloc/habit_bloc.dart';
import '../widgets/category_selector_widget.dart';
import '../widgets/color_picker_widget.dart';

class CreateHabitPage extends StatefulWidget {
  final HabitWithStats? habitWithStats;

  const CreateHabitPage({super.key, this.habitWithStats});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _selectedColorIndex = 0;
  Category? _selectedCategory;
  bool _isLoading = false;

  bool get _isEditing => widget.habitWithStats != null;

  @override
  void initState() {
    super.initState();
    _prefillIfEditing();
  }

  void _prefillIfEditing() {
    if (!_isEditing) return;

    final habit = widget.habitWithStats!.habit;
    _titleController.text = habit.title;
    _descriptionController.text = habit.description ?? '';
    _selectedColorIndex = habit.colorIndex;

    // Pré-seleciona a categoria
    final categoryState = context.read<CategoryCubit>().state;
    if (categoryState is CategoryLoaded) {
      try {
        _selectedCategory = categoryState.categories.firstWhere(
          (c) => c.id == habit.categoryId,
        );
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Hábito' : 'Novo Hábito'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: BlocListener<HabitBloc, HabitState>(
        listener: (context, state) {
          if (state is HabitLoaded) {
            if (_isLoading) {
              Navigator.pop(context);
            }
          }
          if (state is HabitError) {
            setState(() => _isLoading = false);
            AppSnackbar.showError(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Nome do hábito',
                  hint: 'Ex: Meditar por 10 minutos',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Digite o nome do hábito';
                    }
                    if (value.trim().length < 3) {
                      return 'O nome deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Descrição (opcional)',
                  hint: 'Ex: Logo após acordar, por 10 minutos',
                  controller: _descriptionController,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.lg),
                CategorySelectorWidget(
                  selectedCategoryId: _selectedCategory?.id,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                      _selectedColorIndex = category.colorIndex;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                ColorPickerWidget(
                  selectedIndex: _selectedColorIndex,
                  onColorSelected: (index) {
                    setState(() => _selectedColorIndex = index);
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  label: _isEditing ? 'Salvar alterações' : 'Criar hábito',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Cancelar',
                    isOutlined: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      AppSnackbar.showError(context, 'Selecione uma categoria');
      return;
    }

    setState(() => _isLoading = true);

    final habit = Habit(
      id: _isEditing ? widget.habitWithStats!.habit.id : const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      categoryId: _selectedCategory!.id,
      colorIndex: _selectedColorIndex,
      createdAt: _isEditing
          ? widget.habitWithStats!.habit.createdAt
          : DateTime.now(),
    );

    if (_isEditing) {
      context.read<HabitBloc>().add(UpdateHabitEvent(habit));
    } else {
      context.read<HabitBloc>().add(CreateHabitEvent(habit));
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Excluir hábito'),
        content: Text(
          'Deseja excluir "${widget.habitWithStats!.habit.title}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HabitBloc>().add(
                DeleteHabitEvent(widget.habitWithStats!.habit.id),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
