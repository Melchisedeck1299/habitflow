import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitAnalyticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> habitStats;
  final List<Map<String, dynamic>> weeklyProgress;

  const HabitAnalyticsWidget({
    super.key,
    required this.habitStats,
    required this.weeklyProgress,
  });

  @override
  State<HabitAnalyticsWidget> createState() => _HabitAnalyticsWidgetState();
}

class _HabitAnalyticsWidgetState extends State<HabitAnalyticsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.all(4.w),
              child: Text('Analyses des habitudes',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600))),

          // Tab Bar
          TabBar(controller: _tabController, tabs: const [
            Tab(text: 'Statistiques'),
            Tab(text: 'Progression'),
          ]),

          // Tab Bar View
          SizedBox(
              height: 40.h,
              child: TabBarView(controller: _tabController, children: [
                _buildHabitStatsTab(),
                _buildProgressChartTab(),
              ])),
        ]));
  }

  Widget _buildHabitStatsTab() {
    return Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Habitudes les plus réussies',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Expanded(
              child: ListView.separated(
                  itemCount: widget.habitStats.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final habit = widget.habitStats[index];
                    return _buildHabitStatCard(habit);
                  })),
        ]));
  }

  Widget _buildHabitStatCard(Map<String, dynamic> habit) {
    final completionRate = habit["completionRate"] as double;
    final streak = habit["streak"] as int;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(3.w),
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(habit["name"] as String,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 0.5.h),
                  Text(habit["category"] as String,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppTheme.lightTheme.primaryColor)),
                ])),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.getSuccessColor(true),
                      size: 4.w),
                  SizedBox(width: 1.w),
                  Text('$streak',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w600)),
                ])),
          ]),

          SizedBox(height: 2.h),

          // Progress bar
          Row(children: [
            Expanded(
                child: LinearProgressIndicator(
                    value: completionRate / 100,
                    backgroundColor: Theme.of(context).dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor))),
            SizedBox(width: 3.w),
            Text('${completionRate.toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor)),
          ]),
        ]));
  }

  Widget _buildProgressChartTab() {
    return Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Progression hebdomadaire',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 2.h),

          Expanded(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1)),
                  child: Semantics(
                      label: "Graphique de progression hebdomadaire",
                      child: BarChart(BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                  tooltipRoundedRadius: 8,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                        '${rod.toY.round()}%',
                                        const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold));
                                  })),
                          titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() <
                                            widget.weeklyProgress.length) {
                                          return Text(
                                              widget.weeklyProgress[value
                                                  .toInt()]["day"] as String,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall);
                                        }
                                        return const Text('');
                                      },
                                      reservedSize: 30)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text('${value.toInt()}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall);
                                      }))),
                          borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1)),
                          barGroups: widget.weeklyProgress
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            final completion = data["completion"] as double;

                            return BarChartGroupData(x: index, barRods: [
                              BarChartRodData(
                                  toY: completion,
                                  color: AppTheme.lightTheme.primaryColor,
                                  width: 6.w,
                                  borderRadius: BorderRadius.circular(1.w)),
                            ]);
                          }).toList(),
                          gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: Theme.of(context).dividerColor,
                                    strokeWidth: 1);
                              })))))),

          SizedBox(height: 2.h),

          // Weekly summary
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3.w)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeeklyStat(context, 'Moyenne',
                        '${_calculateAverage().toInt()}%', 'trending_up'),
                    _buildWeeklyStat(
                        context, 'Meilleur jour', _getBestDay(), 'star'),
                    _buildWeeklyStat(
                        context, 'Amélioration', '+5%', 'arrow_upward'),
                  ])),
        ]));
  }

  Widget _buildWeeklyStat(
      BuildContext context, String label, String value, String iconName) {
    return Column(children: [
      CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 5.w),
      SizedBox(height: 0.5.h),
      Text(value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor)),
      Text(label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]);
  }

  double _calculateAverage() {
    if (widget.weeklyProgress.isEmpty) return 0.0;

    final total = widget.weeklyProgress
        .fold<double>(0.0, (sum, day) => sum + (day["completion"] as double));

    return total / widget.weeklyProgress.length;
  }

  String _getBestDay() {
    if (widget.weeklyProgress.isEmpty) return 'N/A';

    var bestDay = widget.weeklyProgress.first;
    for (final day in widget.weeklyProgress) {
      if ((day["completion"] as double) > (bestDay["completion"] as double)) {
        bestDay = day;
      }
    }

    return bestDay["day"] as String;
  }
}
