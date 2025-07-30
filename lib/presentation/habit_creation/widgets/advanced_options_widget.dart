import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedOptionsWidget extends StatelessWidget {
  final bool showAdvancedOptions;
  final List<String> selectedTags;
  final List<String> availableTags;
  final TextEditingController notesController;
  final int difficultyLevel;
  final Color selectedColor;
  final List<Color> colorPalette;
  final VoidCallback onToggleAdvanced;
  final Function(List<String>) onTagsChanged;
  final Function(int) onDifficultyChanged;
  final Function(Color) onColorChanged;

  const AdvancedOptionsWidget({
    Key? key,
    required this.showAdvancedOptions,
    required this.selectedTags,
    required this.availableTags,
    required this.notesController,
    required this.difficultyLevel,
    required this.selectedColor,
    required this.colorPalette,
    required this.onToggleAdvanced,
    required this.onTagsChanged,
    required this.onDifficultyChanged,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggleAdvanced,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Options avancées',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: showAdvancedOptions
                      ? 'keyboard_arrow_up'
                      : 'keyboard_arrow_down',
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showAdvancedOptions) ...[
          SizedBox(height: 2.h),

          // Tags section
          _buildTagsSection(context),
          SizedBox(height: 3.h),

          // Notes section
          _buildNotesSection(context),
          SizedBox(height: 3.h),

          // Difficulty level
          _buildDifficultySection(context),
          SizedBox(height: 3.h),

          // Color picker
          _buildColorPicker(context),
        ],
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: availableTags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                List<String> newTags = List.from(selectedTags);
                if (isSelected) {
                  newTags.remove(tag);
                } else {
                  newTags.add(tag);
                }
                onTagsChanged(newTags);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes personnelles',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ajoutez des notes pour vous motiver...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Niveau de difficulté',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: difficultyLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _getDifficultyLabel(difficultyLevel),
                onChanged: (value) {
                  onDifficultyChanged(value.round());
                },
              ),
            ),
            SizedBox(width: 3.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    _getDifficultyColor(difficultyLevel).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getDifficultyLabel(difficultyLevel),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getDifficultyColor(difficultyLevel),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couleur de l\'habitude',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: colorPalette.map((color) {
            final isSelected = selectedColor == color;
            return GestureDetector(
              onTap: () => onColorChanged(color),
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getDifficultyLabel(int level) {
    switch (level) {
      case 1:
        return 'Très facile';
      case 2:
        return 'Facile';
      case 3:
        return 'Moyen';
      case 4:
        return 'Difficile';
      case 5:
        return 'Très difficile';
      default:
        return 'Moyen';
    }
  }

  Color _getDifficultyColor(int level) {
    switch (level) {
      case 1:
        return Color(0xFF2ECC71);
      case 2:
        return Color(0xFF27AE60);
      case 3:
        return Color(0xFFF39C12);
      case 4:
        return Color(0xFFE67E22);
      case 5:
        return Color(0xFFE74C3C);
      default:
        return Color(0xFFF39C12);
    }
  }
}
