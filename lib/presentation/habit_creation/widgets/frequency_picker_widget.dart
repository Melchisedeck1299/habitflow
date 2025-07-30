import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FrequencyPickerWidget extends StatefulWidget {
  final List<String> frequencies;
  final String selectedFrequency;
  final Function(String) onFrequencyChanged;

  const FrequencyPickerWidget({
    Key? key,
    required this.frequencies,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  }) : super(key: key);

  @override
  State<FrequencyPickerWidget> createState() => _FrequencyPickerWidgetState();
}

class _FrequencyPickerWidgetState extends State<FrequencyPickerWidget> {
  int _customDays = 7;
  List<bool> _selectedWeekdays = List.filled(7, false);
  final List<String> _weekdayNames = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fréquence',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedFrequency,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              items: widget.frequencies.map((frequency) {
                return DropdownMenuItem<String>(
                  value: frequency,
                  child: Text(
                    frequency,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  widget.onFrequencyChanged(value);
                }
              },
            ),
          ),
        ),

        // Custom frequency options
        if (widget.selectedFrequency == 'Personnalisé') ...[
          SizedBox(height: 2.h),
          _buildCustomFrequencyOptions(),
        ],
      ],
    );
  }

  Widget _buildCustomFrequencyOptions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jours de la semaine',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: List.generate(_weekdayNames.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeekdays[index] = !_selectedWeekdays[index];
                  });
                },
                child: Container(
                  width: 10.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: _selectedWeekdays[index]
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: _selectedWeekdays[index]
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _weekdayNames[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _selectedWeekdays[index]
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
