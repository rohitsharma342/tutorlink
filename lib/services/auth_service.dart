import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<app_user.User?> getCurrentAppUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    if (userData != null) {
      return app_user.User.fromJson({
        'id': currentUser?.uid ?? '',
        'email': currentUser?.email ?? '',
        'fullName': currentUser?.displayName ?? 'User',
        'role': 'student',
        'gender': 'male',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
    return null;
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserLoginState(true);
      return credential;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String fullName,
    app_user.UserRole role,
    app_user.UserGender gender, {
    String? phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(fullName);
      
      final userData = app_user.User(
        id: credential.user!.uid,
        email: email,
        fullName: fullName,
        role: role,
        gender: gender,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
      
      await _saveUserData(userData);
      await _saveUserLoginState(true);
      
      return credential;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final userData = app_user.User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          fullName: userCredential.user!.displayName ?? 'User',
          role: app_user.UserRole.student,
          gender: app_user.UserGender.male,
          profileImageUrl: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
        );
        await _saveUserData(userData);
      }
      
      await _saveUserLoginState(true);
      return userCredential;
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _clearUserData(),
    ]);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to send email verification: ${e.toString()}');
    }
  }

  Future<void> _saveUserData(app_user.User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, user.toJson().toString());
  }

  Future<void> _saveUserLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}