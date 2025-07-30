import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/habit_prompts_widget.dart';
import './widgets/mood_selector_widget.dart';
import './widgets/photo_attachment_widget.dart';
import './widgets/reflection_input_widget.dart';
import './widgets/voice_input_widget.dart';

class DailyReflection extends StatefulWidget {
  const DailyReflection({Key? key}) : super(key: key);

  @override
  State<DailyReflection> createState() => _DailyReflectionState();
}

class _DailyReflectionState extends State<DailyReflection> {
  final TextEditingController _reflectionController = TextEditingController();
  final FocusNode _reflectionFocusNode = FocusNode();
  String _selectedMood = '😊';
  bool _isVoiceInputActive = false;
  bool _hasUnsavedChanges = false;
  int _characterCount = 0;
  final int _maxCharacters = 2000;

  // Mock data for habit prompts
  final List<Map<String, dynamic>> _habitPrompts = [
    {
      "id": 1,
      "habitName": "Méditation matinale",
      "prompt":
          "Comment votre séance de méditation vous a-t-elle aidé aujourd'hui?",
      "completed": true,
    },
    {
      "id": 2,
      "habitName": "Exercice physique",
      "prompt":
          "Quel type d'exercice avez-vous fait et comment vous sentez-vous?",
      "completed": false,
    },
    {
      "id": 3,
      "habitName": "Lecture quotidienne",
      "prompt": "Qu'avez-vous appris de votre lecture aujourd'hui?",
      "completed": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _reflectionController.addListener(_onTextChanged);
    _autoSaveTimer();
  }

  @override
  void dispose() {
    _reflectionController.removeListener(_onTextChanged);
    _reflectionController.dispose();
    _reflectionFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _characterCount = _reflectionController.text.length;
      _hasUnsavedChanges = _reflectionController.text.isNotEmpty;
    });
  }

  void _autoSaveTimer() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _hasUnsavedChanges) {
        _saveDraft();
        _autoSaveTimer();
      }
    });
  }

  void _saveDraft() {
    // Auto-save functionality
    if (_reflectionController.text.isNotEmpty) {
      // Save to local storage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Brouillon sauvegardé automatiquement'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveReflection() {
    if (_reflectionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez écrire quelque chose avant de sauvegarder'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Save reflection
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Réflexion sauvegardée avec succès!'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _onVoiceInputToggle(bool isActive) {
    setState(() {
      _isVoiceInputActive = isActive;
    });
  }

  void _onVoiceTranscription(String text) {
    setState(() {
      _reflectionController.text += text;
      _isVoiceInputActive = false;
    });
  }

  void _onMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Modifications non sauvegardées'),
          content: Text(
              'Voulez-vous sauvegarder vos modifications avant de quitter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ignorer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _saveDraft();
              },
              child: Text('Sauvegarder'),
            ),
          ],
        ),
      );
      return shouldDiscard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              final canPop = await _onWillPop();
              if (canPop) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Réflexion quotidienne',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              Text(
                '14 juillet 2025',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _saveReflection,
              child: Text(
                'Sauvegarder',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood Selector
              MoodSelectorWidget(
                selectedMood: _selectedMood,
                onMoodSelected: _onMoodSelected,
              ),

              SizedBox(height: 3.h),

              // Habit-specific prompts
              HabitPromptsWidget(
                habitPrompts: _habitPrompts,
                onPromptTap: (prompt) {
                  _reflectionController.text += '\n\n$prompt\n';
                  _reflectionFocusNode.requestFocus();
                },
              ),

              SizedBox(height: 3.h),

              // Main reflection input
              ReflectionInputWidget(
                controller: _reflectionController,
                focusNode: _reflectionFocusNode,
                characterCount: _characterCount,
                maxCharacters: _maxCharacters,
              ),

              SizedBox(height: 2.h),

              // Voice input and photo attachment row
              Row(
                children: [
                  Expanded(
                    child: VoiceInputWidget(
                      isActive: _isVoiceInputActive,
                      onToggle: _onVoiceInputToggle,
                      onTranscription: _onVoiceTranscription,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: PhotoAttachmentWidget(
                      onPhotoSelected: (imagePath) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Photo ajoutée à votre réflexion'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Additional options
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Options supplémentaires',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Share reflection
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Fonctionnalité de partage bientôt disponible'),
                                ),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'share',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            label: Text('Partager'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // View history
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Historique des réflexions bientôt disponible'),
                                ),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'history',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            label: Text('Historique'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h), // Extra space for keyboard
            ],
          ),
        ),
      ),
    );
  }
}
