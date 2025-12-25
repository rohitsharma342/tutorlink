import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  String _currentLanguage = 'en';
  Locale _locale = const Locale('en', '');
  
  String get currentLanguage => _currentLanguage;
  Locale get locale => _locale;
  bool get isRTL => _currentLanguage == 'ar';
  
  LanguageProvider() {
    _loadLanguage();
  }
  
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'en';
      _setLanguage(savedLanguage, notify: false);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading language: $e');
      }
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    await _setLanguage(languageCode, notify: true);
  }
  
  Future<void> _setLanguage(String languageCode, {required bool notify}) async {
    if (_currentLanguage == languageCode) return;
    
    _currentLanguage = languageCode;
    _locale = Locale(languageCode, '');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving language: $e');
      }
    }
    
    if (notify) {
      notifyListeners();
    }
  }
  
  void toggleLanguage() {
    final newLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
    setLanguage(newLanguage);
  }
}