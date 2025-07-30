import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/frequency_picker_widget.dart';
import './widgets/goal_type_widget.dart';
import './widgets/habit_preview_widget.dart';
import './widgets/reminder_settings_widget.dart';
import './widgets/time_selection_widget.dart';

class HabitCreation extends StatefulWidget {
  const HabitCreation({Key? key}) : super(key: key);

  @override
  State<HabitCreation> createState() => _HabitCreationState();
}

class _HabitCreationState extends State<HabitCreation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _scrollController = ScrollController();

  // Form state variables
  String _selectedCategory = '';
  String _selectedFrequency = 'Quotidien';
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isStreakBased = true;
  int _targetQuantity = 1;
  String _quantityUnit = 'fois';
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = TimeOfDay.now();
  List<String> _selectedTags = [];
  int _difficultyLevel = 1;
  Color _selectedColor = const Color(0xFFFF6B35);
  bool _showAdvancedOptions = false;

  // Available options
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Santé', 'icon': 'favorite', 'color': Color(0xFF2ECC71)},
    {'name': 'Productivité', 'icon': 'work', 'color': Color(0xFF4A90E2)},
    {'name': 'Fitness', 'icon': 'fitness_center', 'color': Color(0xFFFF6B35)},
    {'name': 'Apprentissage', 'icon': 'school', 'color': Color(0xFF9B59B6)},
    {
      'name': 'Mindfulness',
      'icon': 'self_improvement',
      'color': Color(0xFFF39C12)
    },
    {'name': 'Social', 'icon': 'people', 'color': Color(0xFFE74C3C)},
  ];

  final List<String> _frequencies = [
    'Quotidien',
    'Hebdomadaire',
    'Personnalisé'
  ];

  final List<String> _availableTags = [
    'Matin',
    'Soir',
    'Rapide',
    'Difficile',
    'Relaxant',
    'Énergisant'
  ];

  final List<Color> _colorPalette = [
    Color(0xFFFF6B35),
    Color(0xFF4A90E2),
    Color(0xFF2ECC71),
    Color(0xFF9B59B6),
    Color(0xFFF39C12),
    Color(0xFFE74C3C),
    Color(0xFF1ABC9C),
    Color(0xFFE67E22),
    Color(0xFF3498DB),
  ];

  @override
  void initState() {
    super.initState();
    _reminderTime = TimeOfDay(
      hour: _selectedTime.hour - 1 < 0 ? 23 : _selectedTime.hour - 1,
      minute: _selectedTime.minute,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _selectedCategory.isNotEmpty;
  }

  void _saveHabit() {
    if (!_isFormValid) return;

    // Create habit data
    final habitData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'category': _selectedCategory,
      'frequency': _selectedFrequency,
      'time':
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'isStreakBased': _isStreakBased,
      'targetQuantity': _targetQuantity,
      'quantityUnit': _quantityUnit,
      'reminderEnabled': _reminderEnabled,
      'reminderTime':
          '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
      'tags': _selectedTags,
      'notes': _notesController.text.trim(),
      'difficultyLevel': _difficultyLevel,
      'color': _selectedColor.value,
      'createdAt': DateTime.now().toIso8601String(),
      'streak': 0,
      'isCompleted': false,
    };

    // Show success animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Habitude "${_nameController.text.trim()}" créée avec succès!'),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to dashboard
    Navigator.pop(context, habitData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Nouvelle Habitude',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Annuler',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _saveHabit : null,
            child: Text(
              'Sauvegarder',
              style: TextStyle(
                color: _isFormValid
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Habit Name Field
                      _buildHabitNameField(),
                      SizedBox(height: 3.h),

                      // Category Selection
                      CategorySelectionWidget(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                            // Auto-set time based on category
                            if (category == 'Fitness') {
                              _selectedTime = TimeOfDay(hour: 7, minute: 0);
                            } else if (category == 'Mindfulness') {
                              _selectedTime = TimeOfDay(hour: 21, minute: 0);
                            }
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Frequency Picker
                      FrequencyPickerWidget(
                        frequencies: _frequencies,
                        selectedFrequency: _selectedFrequency,
                        onFrequencyChanged: (frequency) {
                          setState(() {
                            _selectedFrequency = frequency;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Time Selection
                      TimeSelectionWidget(
                        selectedTime: _selectedTime,
                        onTimeChanged: (time) {
                          setState(() {
                            _selectedTime = time;
                            _reminderTime = TimeOfDay(
                              hour: time.hour - 1 < 0 ? 23 : time.hour - 1,
                              minute: time.minute,
                            );
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Goal Type
                      GoalTypeWidget(
                        isStreakBased: _isStreakBased,
                        targetQuantity: _targetQuantity,
                        quantityUnit: _quantityUnit,
                        onGoalTypeChanged: (isStreak) {
                          setState(() {
                            _isStreakBased = isStreak;
                          });
                        },
                        onQuantityChanged: (quantity) {
                          setState(() {
                            _targetQuantity = quantity;
                          });
                        },
                        onUnitChanged: (unit) {
                          setState(() {
                            _quantityUnit = unit;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Reminder Settings
                      ReminderSettingsWidget(
                        reminderEnabled: _reminderEnabled,
                        reminderTime: _reminderTime,
                        onReminderToggled: (enabled) {
                          setState(() {
                            _reminderEnabled = enabled;
                          });
                        },
                        onReminderTimeChanged: (time) {
                          setState(() {
                            _reminderTime = time;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Advanced Options
                      AdvancedOptionsWidget(
                        showAdvancedOptions: _showAdvancedOptions,
                        selectedTags: _selectedTags,
                        availableTags: _availableTags,
                        notesController: _notesController,
                        difficultyLevel: _difficultyLevel,
                        selectedColor: _selectedColor,
                        colorPalette: _colorPalette,
                        onToggleAdvanced: () {
                          setState(() {
                            _showAdvancedOptions = !_showAdvancedOptions;
                          });
                        },
                        onTagsChanged: (tags) {
                          setState(() {
                            _selectedTags = tags;
                          });
                        },
                        onDifficultyChanged: (level) {
                          setState(() {
                            _difficultyLevel = level;
                          });
                        },
                        onColorChanged: (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Habit Preview
                      if (_nameController.text.trim().isNotEmpty &&
                          _selectedCategory.isNotEmpty)
                        HabitPreviewWidget(
                          habitName: _nameController.text.trim(),
                          category: _selectedCategory,
                          time: _selectedTime,
                          isStreakBased: _isStreakBased,
                          targetQuantity: _targetQuantity,
                          quantityUnit: _quantityUnit,
                          selectedColor: _selectedColor,
                          categories: _categories,
                        ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _saveHabit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.12),
                      foregroundColor: _isFormValid
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.38),
                    ),
                    child: Text(
                      'Créer l\'habitude',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom de l\'habitude',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Ex: Boire 8 verres d\'eau',
            counterText: '${_nameController.text.length}/50',
          ),
          maxLength: 50,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom de l\'habitude est requis';
            }
            return null;
          },
        ),
      ],
    );
  }
}
