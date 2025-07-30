import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimeSelectionWidget extends StatelessWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeChanged;

  const TimeSelectionWidget({
    Key? key,
    required this.selectedTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heure préférée',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () => _selectTime(context),
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
                  iconName: 'access_time',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  _formatTime(selectedTime),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_right',
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
        SizedBox(height: 1.h),
        Text(
          _getTimeRecommendation(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              entryModeIconColor: Theme.of(context).colorScheme.primary,
              helpTextStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getTimeRecommendation() {
    final hour = selectedTime.hour;

    if (hour >= 5 && hour < 12) {
      return 'Parfait pour commencer la journée avec énergie';
    } else if (hour >= 12 && hour < 17) {
      return 'Idéal pour maintenir la motivation l\'après-midi';
    } else if (hour >= 17 && hour < 22) {
      return 'Excellent moment pour se détendre et réfléchir';
    } else {
      return 'Assurez-vous que cette heure convient à votre routine';
    }
  }
}
