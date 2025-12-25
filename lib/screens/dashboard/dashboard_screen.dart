import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tutor_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/user.dart';
import '../../widgets/tutor_card.dart';
import '../../widgets/common/language_switcher.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../profile/tutor_profile_screen.dart';
import '../chat/chat_screen.dart';
import 'tutor_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedSubjects = [];
  List<String> _selectedGradeLevels = [];
  String _selectedCity = '';
  double _maxRate = 1000;
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TutorProvider>(context, listen: false).loadTutors();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localization = AppLocalizations.of(context)!;
    
    return Directionality(
      textDirection: languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: _buildAppBar(localization, authProvider),
        body: authProvider.currentUser?.role == UserRole.tutor
            ? const TutorDashboardScreen()
            : _buildStudentDashboard(localization),
        floatingActionButton: authProvider.currentUser?.role == UserRole.student
            ? FloatingActionButton(
                onPressed: () => _showFilterModal(localization),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.filter_list, color: Colors.white),
              )
            : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations localization, AuthProvider authProvider) {
    return AppBar(
      title: Text(
        localization.translate('dashboard'),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () => _showNotifications(localization),
        ),
        const LanguageSwitcher(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.person, color: Colors.white),
          onSelected: (value) {
            if (value == 'logout') {
              authProvider.signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Text(localization.translate('profile')),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Text(localization.translate('settings')),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Text(localization.translate('logout')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentDashboard(AppLocalizations localization) {
    return Column(
      children: [
        _buildSearchBar(localization),
        _buildTabBar(localization),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTutorsList(localization),
              _buildFavoritesList(localization),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations localization) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: localization.translate('search_tutors'),
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          Provider.of<TutorProvider>(context, listen: false).searchTutors(value);
        },
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations localization) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: [
          Tab(text: localization.translate('all_tutors')),
          Tab(text: localization.translate('favorites')),
        ],
      ),
    );
  }

  Widget _buildTutorsList(AppLocalizations localization) {
    return Consumer<TutorProvider>(
      builder: (context, tutorProvider, child) {
        if (tutorProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (tutorProvider.filteredTutors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  localization.translate('no_tutors_found'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localization.translate('try_different_search'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tutorProvider.filteredTutors.length,
          itemBuilder: (context, index) {
            final tutor = tutorProvider.filteredTutors[index];
            return TutorCard(
              tutor: tutor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorProfileScreen(tutor: tutor),
                  ),
                );
              },
              onFavorite: () {
                tutorProvider.toggleFavorite(tutor.id);
              },
              onChat: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      tutorId: tutor.id,
                      tutorName: tutor.user.fullName,
                    ),
                  ),
                );
              },
              isFavorite: tutorProvider.isFavorite(tutor.id),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesList(AppLocalizations localization) {
    return Consumer<TutorProvider>(
      builder: (context, tutorProvider, child) {
        final favoriteTutors = tutorProvider.favoriteTutors;
        
        if (favoriteTutors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  localization.translate('no_favorites_yet'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localization.translate('add_tutors_to_favorites'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteTutors.length,
          itemBuilder: (context, index) {
            final tutor = favoriteTutors[index];
            return TutorCard(
              tutor: tutor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorProfileScreen(tutor: tutor),
                  ),
                );
              },
              onFavorite: () {
                tutorProvider.toggleFavorite(tutor.id);
              },
              onChat: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      tutorId: tutor.id,
                      tutorName: tutor.user.fullName,
                    ),
                  ),
                );
              },
              isFavorite: true,
            );
          },
        );
      },
    );
  }

  void _showFilterModal(AppLocalizations localization) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('filter_tutors'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            _buildSubjectFilter(localization, setState),
                            const SizedBox(height: 20),
                            _buildGradeLevelFilter(localization, setState),
                            const SizedBox(height: 20),
                            _buildCityFilter(localization, setState),
                            const SizedBox(height: 20),
                            _buildRateFilter(localization, setState),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _clearFilters();
                                Navigator.pop(context);
                              },
                              child: Text(localization.translate('clear_all')),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _applyFilters();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: Text(
                                localization.translate('apply_filters'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSubjectFilter(AppLocalizations localization, StateSetter setState) {
    final subjects = ['Math', 'Science', 'English', 'Arabic', 'Physics', 'Chemistry'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('subjects'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subjects.map((subject) {
            final isSelected = _selectedSubjects.contains(subject);
            return FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSubjects.add(subject);
                  } else {
                    _selectedSubjects.remove(subject);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGradeLevelFilter(AppLocalizations localization, StateSetter setState) {
    final gradeLevels = ['Elementary', 'Middle School', 'High School', 'University'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('grade_levels'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: gradeLevels.map((level) {
            final isSelected = _selectedGradeLevels.contains(level);
            return FilterChip(
              label: Text(level),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedGradeLevels.add(level);
                  } else {
                    _selectedGradeLevels.remove(level);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCityFilter(AppLocalizations localization, StateSetter setState) {
    final cities = ['Riyadh', 'Jeddah', 'Dammam', 'Mecca', 'Medina'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('city'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedCity.isEmpty ? null : _selectedCity,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          hint: Text(localization.translate('select_city')),
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCity = value ?? '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildRateFilter(AppLocalizations localization, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('max_hourly_rate'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          '${_maxRate.round()} ${localization.translate('sar')}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Slider(
          value: _maxRate,
          min: 50,
          max: 1000,
          divisions: 19,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              _maxRate = value;
            });
          },
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedSubjects.clear();
      _selectedGradeLevels.clear();
      _selectedCity = '';
      _maxRate = 1000;
    });
    Provider.of<TutorProvider>(context, listen: false).clearFilters();
  }

  void _applyFilters() {
    Provider.of<TutorProvider>(context, listen: false).applyFilters(
      subjects: _selectedSubjects,
      gradeLevels: _selectedGradeLevels,
      city: _selectedCity,
      maxRate: _maxRate,
    );
  }

  void _showNotifications(AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localization.translate('notifications')),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      index == 0 ? Icons.message : 
                      index == 1 ? Icons.star : Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    index == 0 ? 'New message from tutor' :
                    index == 1 ? 'Please rate your lesson' :
                    'Welcome to TutorLink!',
                  ),
                  subtitle: Text(
                    index == 0 ? '2 hours ago' :
                    index == 1 ? '1 day ago' :
                    '3 days ago',
                  ),
                  isThreeLine: false,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localization.translate('close'),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}