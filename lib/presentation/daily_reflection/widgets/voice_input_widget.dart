import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final bool isActive;
  final Function(bool) onToggle;
  final Function(String) onTranscription;

  const VoiceInputWidget({
    Key? key,
    required this.isActive,
    required this.onToggle,
    required this.onTranscription,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String _currentTranscription = '';
  double _confidenceLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VoiceInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startListening();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopListening();
    }
  }

  void _startListening() {
    _pulseController.repeat(reverse: true);
    // Simulate voice recognition
    _simulateVoiceRecognition();
  }

  void _stopListening() {
    _pulseController.stop();
    _pulseController.reset();
    if (_currentTranscription.isNotEmpty) {
      widget.onTranscription(_currentTranscription);
      setState(() {
        _currentTranscription = '';
        _confidenceLevel = 0.0;
      });
    }
  }

  void _simulateVoiceRecognition() {
    // Simulate real-time transcription
    final sampleTexts = [
      'Aujourd\'hui a été une journée productive.',
      'J\'ai réussi à terminer mes tâches importantes.',
      'Je me sens reconnaissant pour les opportunités.',
      'Demain, je veux me concentrer sur mes objectifs.',
    ];

    if (widget.isActive) {
      Future.delayed(Duration(seconds: 2), () {
        if (widget.isActive) {
          setState(() {
            _currentTranscription =
                sampleTexts[DateTime.now().millisecond % sampleTexts.length];
            _confidenceLevel = 0.85 + (DateTime.now().millisecond % 15) / 100;
          });
        }
      });
    }
  }

  void _toggleVoiceInput() {
    widget.onToggle(!widget.isActive);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: widget.isActive
            ? AppTheme.lightTheme.colorScheme.primaryContainer
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: widget.isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Voice input button
          GestureDetector(
            onTap: _toggleVoiceInput,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isActive ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isActive ? 'mic' : 'mic_none',
                        color: widget.isActive
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Status text
          Text(
            widget.isActive ? 'Écoute en cours...' : 'Appuyez pour parler',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: widget.isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),

          // Real-time transcription
          if (widget.isActive && _currentTranscription.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentTranscription,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        'Confiance: ${(_confidenceLevel * 100).toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _confidenceLevel,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _confidenceLevel > 0.7
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getWarningColor(true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Action buttons when active
          if (widget.isActive) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTranscription = '';
                        _confidenceLevel = 0.0;
                      });
                    },
                    child: Text('Effacer'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _stopListening,
                    child: Text('Terminer'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
