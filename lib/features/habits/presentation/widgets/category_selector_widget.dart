import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/domain/utils/category_icon_helper.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';

class CategorySelectorWidget extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<Category> onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categoria', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is! CategoryLoaded) {
              return const CircularProgressIndicator();
            }

            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: state.categories.map((category) {
                final isSelected = category.id == selectedCategoryId;
                final color = AppColors.categoryColors[category.colorIndex];

                return GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.chipRadius,
                      ),
                      border: Border.all(
                        color: isSelected ? color : AppColors.divider,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CategoryIconHelper.getIcon(category.icon),
                          size: 16,
                          color: isSelected ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
