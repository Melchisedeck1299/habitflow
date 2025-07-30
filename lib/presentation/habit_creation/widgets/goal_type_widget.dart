import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GoalTypeWidget extends StatelessWidget {
  final bool isStreakBased;
  final int targetQuantity;
  final String quantityUnit;
  final Function(bool) onGoalTypeChanged;
  final Function(int) onQuantityChanged;
  final Function(String) onUnitChanged;

  const GoalTypeWidget({
    Key? key,
    required this.isStreakBased,
    required this.targetQuantity,
    required this.quantityUnit,
    required this.onGoalTypeChanged,
    required this.onQuantityChanged,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type d\'objectif',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),

        // Goal type toggle
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onGoalTypeChanged(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isStreakBased
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: isStreakBased
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                          size: 24,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Série',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: isStreakBased
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onGoalTypeChanged(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: !isStreakBased
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: !isStreakBased
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                          size: 24,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Quantité',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: !isStreakBased
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Goal explanation
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName:
                    isStreakBased ? 'local_fire_department' : 'trending_up',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  isStreakBased
                      ? 'Objectif basé sur la continuité. Maintenez votre série jour après jour!'
                      : 'Objectif basé sur la quantité. Définissez combien de fois par jour.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),

        // Quantity settings for non-streak goals
        if (!isStreakBased) ...[
          SizedBox(height: 2.h),
          _buildQuantitySettings(context),
        ],
      ],
    );
  }

  Widget _buildQuantitySettings(BuildContext context) {
    final List<String> units = [
      'fois',
      'minutes',
      'heures',
      'pages',
      'verres',
      'km'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objectif quotidien',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Quantity input
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                child: TextFormField(
                  initialValue: targetQuantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '1',
                  ),
                  onChanged: (value) {
                    final quantity = int.tryParse(value) ?? 1;
                    onQuantityChanged(quantity);
                  },
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // Unit dropdown
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: quantityUnit,
                    isExpanded: true,
                    items: units.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(
                          unit,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onUnitChanged(value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
