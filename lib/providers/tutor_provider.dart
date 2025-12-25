import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tutor.dart';
import '../services/data_service.dart';

class TutorProvider with ChangeNotifier {
  static const String _favoritesKey = 'favorite_tutors';
  
  List<Tutor> _allTutors = [];
  List<Tutor> _filteredTutors = [];
  List<String> _favoriteTutorIds = [];
  bool _isLoading = false;
  String _searchQuery = '';
  
  Map<String, dynamic> _currentFilters = {};
  
  List<Tutor> get allTutors => _allTutors;
  List<Tutor> get filteredTutors => _filteredTutors;
  List<Tutor> get favoriteTutors => _allTutors.where((tutor) => _favoriteTutorIds.contains(tutor.id)).toList();
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get currentFilters => _currentFilters;
  
  TutorProvider() {
    _loadFavorites();
  }
  
  Future<void> loadTutors() async {
    _setLoading(true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allTutors = DataService.getAllTutors();
      _filteredTutors = List.from(_allTutors);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tutors: $e');
      }
    } finally {
      _setLoading(false);
    }
  }
  
  void searchTutors(String query) {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredTutors = List.from(_allTutors);
    } else {
      _filteredTutors = DataService.searchTutors(query);
    }
    
    _applyCurrentFilters();
    notifyListeners();
  }
  
  void applyFilters({
    List<String>? subjects,
    List<String>? gradeLevels,
    String? city,
    double? maxRate,
    bool? isVerified,
  }) {
    _currentFilters = {
      if (subjects != null && subjects.isNotEmpty) 'subjects': subjects,
      if (gradeLevels != null && gradeLevels.isNotEmpty) 'gradeLevels': gradeLevels,
      if (city != null && city.isNotEmpty) 'city': city,
      if (maxRate != null) 'maxRate': maxRate,
      if (isVerified != null) 'isVerified': isVerified,
    };
    
    _applyCurrentFilters();
    notifyListeners();
  }
  
  void clearFilters() {
    _currentFilters.clear();
    _filteredTutors = _searchQuery.isEmpty 
        ? List.from(_allTutors) 
        : DataService.searchTutors(_searchQuery);
    notifyListeners();
  }
  
  void _applyCurrentFilters() {
    if (_currentFilters.isEmpty) return;
    
    _filteredTutors = DataService.filterTutors(
      subjects: _currentFilters['subjects'],
      gradeLevels: _currentFilters['gradeLevels'],
      city: _currentFilters['city'],
      maxRate: _currentFilters['maxRate'],
      isVerified: _currentFilters['isVerified'],
    );
    
    if (_searchQuery.isNotEmpty) {
      _filteredTutors = _filteredTutors.where((tutor) {
        return tutor.user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               tutor.subjects.any((subject) => subject.toLowerCase().contains(_searchQuery.toLowerCase())) ||
               tutor.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               tutor.area.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }
  
  Future<void> toggleFavorite(String tutorId) async {
    if (_favoriteTutorIds.contains(tutorId)) {
      _favoriteTutorIds.remove(tutorId);
    } else {
      _favoriteTutorIds.add(tutorId);
    }
    
    await _saveFavorites();
    notifyListeners();
  }
  
  bool isFavorite(String tutorId) {
    return _favoriteTutorIds.contains(tutorId);
  }
  
  Tutor? getTutorById(String id) {
    return DataService.getTutorById(id);
  }
  
  List<String> getAllSubjects() {
    return DataService.getAllSubjects();
  }
  
  List<String> getAllGradeLevels() {
    return DataService.getAllGradeLevels();
  }
  
  List<String> getAllCities() {
    return DataService.getAllCities();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        _favoriteTutorIds = favoritesList.cast<String>();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading favorites: $e');
      }
    }
  }
  
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(_favoriteTutorIds);
      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving favorites: $e');
      }
    }
  }
  
  void updateTutorRating(String tutorId, double rating) {
    final tutorIndex = _allTutors.indexWhere((t) => t.id == tutorId);
    if (tutorIndex != -1) {
      final tutor = _allTutors[tutorIndex];
      final newTotalRatings = tutor.totalRatings + 1;
      final newAverageRating = ((tutor.averageRating * tutor.totalRatings) + rating) / newTotalRatings;
      
      final updatedTutor = Tutor(
        id: tutor.id,
        user: tutor.user,
        bio: tutor.bio,
        subjects: tutor.subjects,
        gradeLevels: tutor.gradeLevels,
        teachingTypes: tutor.teachingTypes,
        area: tutor.area,
        city: tutor.city,
        hourlyRate: tutor.hourlyRate,
        yearsOfExperience: tutor.yearsOfExperience,
        averageRating: newAverageRating,
        totalRatings: newTotalRatings,
        introVideoUrl: tutor.introVideoUrl,
        hasActiveSubscription: tutor.hasActiveSubscription,
        subscriptionExpiryDate: tutor.subscriptionExpiryDate,
        profileViews: tutor.profileViews,
        isVerified: tutor.isVerified,
      );
      
      _allTutors[tutorIndex] = updatedTutor;
      
      final filteredIndex = _filteredTutors.indexWhere((t) => t.id == tutorId);
      if (filteredIndex != -1) {
        _filteredTutors[filteredIndex] = updatedTutor;
      }
      
      notifyListeners();
    }
  }
  
  void incrementTutorViews(String tutorId) {
    final tutorIndex = _allTutors.indexWhere((t) => t.id == tutorId);
    if (tutorIndex != -1) {
      final tutor = _allTutors[tutorIndex];
      final updatedTutor = Tutor(
        id: tutor.id,
        user: tutor.user,
        bio: tutor.bio,
        subjects: tutor.subjects,
        gradeLevels: tutor.gradeLevels,
        teachingTypes: tutor.teachingTypes,
        area: tutor.area,
        city: tutor.city,
        hourlyRate: tutor.hourlyRate,
        yearsOfExperience: tutor.yearsOfExperience,
        averageRating: tutor.averageRating,
        totalRatings: tutor.totalRatings,
        introVideoUrl: tutor.introVideoUrl,
        hasActiveSubscription: tutor.hasActiveSubscription,
        subscriptionExpiryDate: tutor.subscriptionExpiryDate,
        profileViews: tutor.profileViews + 1,
        isVerified: tutor.isVerified,
      );
      
      _allTutors[tutorIndex] = updatedTutor;
      
      final filteredIndex = _filteredTutors.indexWhere((t) => t.id == tutorId);
      if (filteredIndex != -1) {
        _filteredTutors[filteredIndex] = updatedTutor;
      }
      
      notifyListeners();
    }
  }
}