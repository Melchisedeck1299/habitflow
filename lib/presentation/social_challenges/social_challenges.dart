import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_challenge_widget.dart';
import './widgets/challenge_card_widget.dart';
import './widgets/challenge_filter_widget.dart';
import './widgets/featured_challenge_widget.dart';

class SocialChallenges extends StatefulWidget {
  const SocialChallenges({Key? key}) : super(key: key);

  @override
  State<SocialChallenges> createState() => _SocialChallengesState();
}

class _SocialChallengesState extends State<SocialChallenges>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isRefreshing = false;
  String _selectedFilter = 'Tous';
  bool _showSearch = false;

  // Mock data for challenges
  final List<Map<String, dynamic>> featuredChallenges = [
    {
      "id": 1,
      "title": "Défi 30 Jours de Méditation",
      "description": "Méditez 10 minutes chaque jour pendant 30 jours",
      "image":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg",
      "participants": 1247,
      "duration": "30 jours",
      "category": "Bien-être",
      "difficulty": "Débutant",
      "progress": 0.65,
      "isJoined": false,
      "startDate": "2025-01-15",
      "endDate": "2025-02-14",
      "reward": "Badge Zen Master",
      "createdBy": "Marie Dubois"
    },
    {
      "id": 2,
      "title": "Course Matinale Challenge",
      "description": "Courir 5km chaque matin pendant 21 jours",
      "image":
          "https://images.pexels.com/photos/2402777/pexels-photo-2402777.jpeg",
      "participants": 892,
      "duration": "21 jours",
      "category": "Fitness",
      "difficulty": "Intermédiaire",
      "progress": 0.43,
      "isJoined": true,
      "startDate": "2025-01-10",
      "endDate": "2025-01-31",
      "reward": "Badge Runner",
      "createdBy": "Pierre Martin"
    },
    {
      "id": 3,
      "title": "Lecture Quotidienne",
      "description": "Lire 30 pages par jour pendant 14 jours",
      "image":
          "https://images.pexels.com/photos/1370298/pexels-photo-1370298.jpeg",
      "participants": 634,
      "duration": "14 jours",
      "category": "Éducation",
      "difficulty": "Facile",
      "progress": 0.28,
      "isJoined": false,
      "startDate": "2025-01-12",
      "endDate": "2025-01-26",
      "reward": "Badge Bookworm",
      "createdBy": "Sophie Laurent"
    }
  ];

  final List<Map<String, dynamic>> allChallenges = [
    {
      "id": 4,
      "title": "Hydratation Challenge",
      "description": "Boire 2L d'eau par jour pendant 7 jours",
      "image":
          "https://images.pexels.com/photos/416528/pexels-photo-416528.jpeg",
      "participants": 2156,
      "duration": "7 jours",
      "category": "Santé",
      "difficulty": "Facile",
      "progress": 0.85,
      "isJoined": true,
      "startDate": "2025-01-08",
      "endDate": "2025-01-15",
      "reward": "Badge Hydro Hero",
      "createdBy": "Dr. Amélie Rousseau"
    },
    {
      "id": 5,
      "title": "Gratitude Journal",
      "description": "Écrire 3 choses positives chaque soir",
      "image":
          "https://images.pexels.com/photos/1925536/pexels-photo-1925536.jpeg",
      "participants": 1543,
      "duration": "21 jours",
      "category": "Bien-être",
      "difficulty": "Facile",
      "progress": 0.52,
      "isJoined": false,
      "startDate": "2025-01-05",
      "endDate": "2025-01-26",
      "reward": "Badge Grateful Heart",
      "createdBy": "Lucie Moreau"
    },
    {
      "id": 6,
      "title": "Pas de Réseaux Sociaux",
      "description": "Éviter les réseaux sociaux pendant 10 jours",
      "image":
          "https://images.pexels.com/photos/267350/pexels-photo-267350.jpeg",
      "participants": 987,
      "duration": "10 jours",
      "category": "Productivité",
      "difficulty": "Difficile",
      "progress": 0.30,
      "isJoined": false,
      "startDate": "2025-01-20",
      "endDate": "2025-01-30",
      "reward": "Badge Digital Detox",
      "createdBy": "Thomas Leroy"
    },
    {
      "id": 7,
      "title": "Cuisine Maison",
      "description": "Préparer tous ses repas à la maison",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
      "participants": 756,
      "duration": "14 jours",
      "category": "Nutrition",
      "difficulty": "Intermédiaire",
      "progress": 0.71,
      "isJoined": true,
      "startDate": "2025-01-01",
      "endDate": "2025-01-15",
      "reward": "Badge Chef Maison",
      "createdBy": "Chef Antoine"
    }
  ];

  final List<Map<String, dynamic>> activeChallenges = [
    {
      "id": 2,
      "title": "Course Matinale Challenge",
      "currentStreak": 12,
      "totalDays": 21,
      "rank": 23,
      "totalParticipants": 892,
      "nextCheckIn": "Demain 07:00",
      "progress": 0.57,
      "canCheckIn": true
    },
    {
      "id": 4,
      "title": "Hydratation Challenge",
      "currentStreak": 6,
      "totalDays": 7,
      "rank": 8,
      "totalParticipants": 2156,
      "nextCheckIn": "Aujourd'hui 20:00",
      "progress": 0.86,
      "canCheckIn": false
    },
    {
      "id": 7,
      "title": "Cuisine Maison",
      "currentStreak": 10,
      "totalDays": 14,
      "rank": 45,
      "totalParticipants": 756,
      "nextCheckIn": "Aujourd'hui 19:00",
      "progress": 0.71,
      "canCheckIn": true
    }
  ];

  final List<String> filterOptions = [
    'Tous',
    'Bien-être',
    'Fitness',
    'Nutrition',
    'Productivité',
    'Éducation',
    'Santé'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => ChallengeFilterWidget(
        selectedFilter: _selectedFilter,
        filterOptions: filterOptions,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  void _joinChallenge(Map<String, dynamic> challenge) {
    setState(() {
      challenge['isJoined'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vous avez rejoint "${challenge['title']}"!'),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openChallengeDetail(Map<String, dynamic> challenge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildChallengeDetailSheet(challenge),
    );
  }

  Widget _buildChallengeDetailSheet(Map<String, dynamic> challenge) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    challenge['title'],
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: challenge['image'],
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    'Description',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    challenge['description'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),

                  SizedBox(height: 2.h),

                  // Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          'Durée',
                          challenge['duration'],
                          'schedule',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          'Participants',
                          '${challenge['participants']}',
                          'group',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          'Difficulté',
                          challenge['difficulty'],
                          'trending_up',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          'Récompense',
                          challenge['reward'],
                          'emoji_events',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Join button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: challenge['isJoined']
                          ? null
                          : () {
                              _joinChallenge(challenge);
                              Navigator.pop(context);
                            },
                      child: Text(
                        challenge['isJoined']
                            ? 'Déjà rejoint'
                            : 'Rejoindre le défi',
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.only(right: 2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredChallenges() {
    if (_selectedFilter == 'Tous') {
      return allChallenges;
    }
    return allChallenges
        .where((challenge) => challenge['category'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Rechercher des défis...',
                  border: InputBorder.none,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              )
            : const Text('Défis Sociaux'),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _showSearch ? 'close' : 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterDialog,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Découvrir'),
            Tab(text: 'Mes Défis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildMyChallengesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to challenge creation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Création de défi bientôt disponible!'),
            ),
          );
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Featured challenges section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    'Défis en vedette',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: featuredChallenges.length,
                    itemBuilder: (context, index) {
                      return FeaturedChallengeWidget(
                        challenge: featuredChallenges[index],
                        onTap: () =>
                            _openChallengeDetail(featuredChallenges[index]),
                        onJoin: () => _joinChallenge(featuredChallenges[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),

          // All challenges section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tous les défis',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  if (_selectedFilter != 'Tous')
                    Chip(
                      label: Text(_selectedFilter),
                      onDeleted: () {
                        setState(() {
                          _selectedFilter = 'Tous';
                        });
                      },
                      deleteIcon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Challenge list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final filteredChallenges = _getFilteredChallenges();
                if (index >= filteredChallenges.length) return null;

                return ChallengeCardWidget(
                  challenge: filteredChallenges[index],
                  onTap: () => _openChallengeDetail(filteredChallenges[index]),
                  onJoin: () => _joinChallenge(filteredChallenges[index]),
                );
              },
              childCount: _getFilteredChallenges().length,
            ),
          ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildMyChallengesTab() {
    return activeChallenges.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: activeChallenges.length,
            itemBuilder: (context, index) {
              return ActiveChallengeWidget(
                challenge: activeChallenges[index],
                onCheckIn: () {
                  setState(() {
                    activeChallenges[index]['canCheckIn'] = false;
                    activeChallenges[index]['currentStreak']++;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Check-in réussi! Série: ${activeChallenges[index]['currentStreak']}'),
                      backgroundColor: AppTheme.getSuccessColor(true),
                    ),
                  );
                },
              );
            },
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
              iconName: 'emoji_events',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 80,
            ),
            SizedBox(height: 2.h),
            Text(
              'Aucun défi actif',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Rejoignez des défis pour commencer votre parcours de développement personnel!',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              child: const Text('Découvrir des défis'),
            ),
          ],
        ),
      ),
    );
  }
}
