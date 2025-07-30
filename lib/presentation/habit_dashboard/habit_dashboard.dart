import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/daily_progress_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/habit_card_widget.dart';

class HabitDashboard extends StatefulWidget {
  const HabitDashboard({super.key});

  @override
  State<HabitDashboard> createState() => _HabitDashboardState();
}

class _HabitDashboardState extends State<HabitDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  int _selectedIndex = 0;

  // Mock data for habits
  final List<Map<String, dynamic>> todayHabits = [
    {
      "id": 1,
      "name": "Méditation matinale",
      "streak": 15,
      "isCompleted": true,
      "targetTime": "08:00",
      "category": "Bien-être",
      "icon": "self_improvement",
      "progress": 1.0,
      "description": "10 minutes de méditation pour commencer la journée",
      "completedAt": DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      "id": 2,
      "name": "Boire 2L d'eau",
      "streak": 8,
      "isCompleted": false,
      "targetTime": "Toute la journée",
      "category": "Santé",
      "icon": "local_drink",
      "progress": 0.6,
      "description": "Maintenir une bonne hydratation",
      "completedAt": null,
    },
    {
      "id": 3,
      "name": "Lecture 30 min",
      "streak": 22,
      "isCompleted": false,
      "targetTime": "20:00",
      "category": "Développement",
      "icon": "menu_book",
      "progress": 0.0,
      "description": "Lire pour enrichir ses connaissances",
      "completedAt": null,
    },
    {
      "id": 4,
      "name": "Exercice physique",
      "streak": 5,
      "isCompleted": true,
      "targetTime": "18:00",
      "category": "Fitness",
      "icon": "fitness_center",
      "progress": 1.0,
      "description": "30 minutes d'activité physique",
      "completedAt": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 5,
      "name": "Gratitude journal",
      "streak": 12,
      "isCompleted": false,
      "targetTime": "22:00",
      "category": "Bien-être",
      "icon": "favorite",
      "progress": 0.0,
      "description": "Noter 3 choses pour lesquelles je suis reconnaissant",
      "completedAt": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Habitudes synchronisées'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleHabitCompletion(int habitId) {
    setState(() {
      final habitIndex =
          todayHabits.indexWhere((habit) => habit['id'] == habitId);
      if (habitIndex != -1) {
        final habit = todayHabits[habitIndex];
        final wasCompleted = habit['isCompleted'] as bool;

        habit['isCompleted'] = !wasCompleted;
        habit['progress'] = !wasCompleted ? 1.0 : 0.0;
        habit['completedAt'] = !wasCompleted ? DateTime.now() : null;

        if (!wasCompleted) {
          habit['streak'] = (habit['streak'] as int) + 1;
        }
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _showHabitActions(BuildContext context, Map<String, dynamic> habit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              habit['name'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit habit
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bar_chart',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Statistiques'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to habit statistics
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, habit);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer l\'habitude'),
        content:
            Text('Êtes-vous sûr de vouloir supprimer "${habit['name']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                todayHabits.removeWhere((h) => h['id'] == habit['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Habitude supprimée')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/social-challenges');
        break;
      case 2:
        Navigator.pushNamed(context, '/user-profile');
        break;
      case 3:
        // Show more options
        _showMoreOptions();
        break;
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Plus d\'options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'book',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Journal de réflexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/daily-reflection');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text('Aide'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedHabits =
        todayHabits.where((habit) => habit['isCompleted'] as bool).length;
    final totalHabits = todayHabits.length;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                onTap: _navigateToTab,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'home',
                      color: _selectedIndex == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Habitudes',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'emoji_events',
                      color: _selectedIndex == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Défis',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'person',
                      color: _selectedIndex == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Profil',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'more_horiz',
                      color: _selectedIndex == 3
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Plus',
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: CustomScrollView(
                  slivers: [
                    // Greeting Header
                    SliverToBoxAdapter(
                      child: GreetingHeaderWidget(),
                    ),

                    // Daily Progress Summary
                    SliverToBoxAdapter(
                      child: DailyProgressWidget(
                        completedHabits: completedHabits,
                        totalHabits: totalHabits,
                        todayHabits: todayHabits,
                      ),
                    ),

                    // Habits List
                    todayHabits.isEmpty
                        ? SliverFillRemaining(
                            child: _buildEmptyState(),
                          )
                        : SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final habit = todayHabits[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: HabitCardWidget(
                                      habit: habit,
                                      onToggleCompletion: () =>
                                          _toggleHabitCompletion(
                                              habit['id'] as int),
                                      onLongPress: () =>
                                          _showHabitActions(context, habit),
                                    ),
                                  );
                                },
                                childCount: todayHabits.length,
                              ),
                            ),
                          ),

                    // Bottom spacing
                    SliverToBoxAdapter(
                      child: SizedBox(height: 10.h),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/habit-creation');
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'track_changes',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'Aucune habitude aujourd\'hui',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Commencez votre parcours en créant votre première habitude',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/habit-creation');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Créer votre première habitude'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
