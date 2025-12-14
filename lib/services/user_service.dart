import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_management_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final _userManagementService = UserManagementService();
  Map<String, dynamic>? _currentUser;
  bool _initialized = false;

  // Get current user
  Map<String, dynamic>? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Check if current user is banned
  bool get isBanned {
    if (_currentUser == null) return false;
    return _userManagementService.isUserBanned(_currentUser!['email']);
  }

  // Initialize and load saved user session
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // First, check Firebase Auth for current user
      final firebaseUser = FirebaseAuth.instance.currentUser;
      
      if (firebaseUser != null) {
        // User is authenticated in Firebase, get data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final email = userData['email'] ?? firebaseUser.email ?? '';
          
          // Check if user is banned
          if (userData['isBanned'] == true || _userManagementService.isUserBanned(email)) {
            await clearSession();
            await FirebaseAuth.instance.signOut();
            debugPrint('UserService: User $email is banned, session cleared');
          } else {
            _currentUser = {
              'email': email,
              'name': userData['name'] ?? _extractNameFromEmail(email),
              'profileImageUrl': userData['profileImageUrl'],
            };
            debugPrint('UserService: Session restored from Firebase for $email');
          }
        } else {
          // User exists in Auth but not in Firestore
          final email = firebaseUser.email ?? '';
          _currentUser = {
            'email': email,
            'name': _extractNameFromEmail(email),
            'profileImageUrl': null,
          };
          debugPrint('UserService: Session restored from Firebase Auth for $email');
        }
      } else {
        // Fallback to SharedPreferences if Firebase Auth is not available
        final prefs = await SharedPreferences.getInstance();
        final savedEmail = prefs.getString('user_email');
        final savedName = prefs.getString('user_name');
        final savedProfileImageUrl = prefs.getString('user_profile_image_url');

        if (savedEmail != null && savedEmail.isNotEmpty) {
          // Check if user is still banned
          if (!_userManagementService.isUserBanned(savedEmail)) {
            _currentUser = {
              'email': savedEmail,
              'name': savedName ?? _extractNameFromEmail(savedEmail),
              'profileImageUrl': savedProfileImageUrl,
            };
            debugPrint('UserService: Session restored from SharedPreferences for $savedEmail');
          } else {
            // User is banned, clear saved session
            await clearSession();
            debugPrint('UserService: User $savedEmail is banned, session cleared');
          }
        } else {
          debugPrint('UserService: No saved session found');
        }
      }
      _initialized = true;
    } catch (e) {
      // If initialization fails, continue without saved session
      debugPrint('UserService: Error initializing session: $e');
      _initialized = true;
    }
  }

  // Set current user (called after login)
  Future<void> setUser({
    required String email,
    String? name,
    String? profileImageUrl,
  }) async {
    final displayName = name ?? _extractNameFromEmail(email);
    _currentUser = {
      'email': email,
      'name': displayName,
      'profileImageUrl': profileImageUrl,
    };

    // Save to persistent storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', displayName);
      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        await prefs.setString('user_profile_image_url', profileImageUrl);
      } else {
        await prefs.remove('user_profile_image_url');
      }
      // SharedPreferences automatically commits changes
      debugPrint('UserService: Session saved for $email');
    } catch (e) {
      // If saving fails, continue without persistence
      debugPrint('UserService: Error saving session: $e');
    }
  }

  // Clear saved session
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_profile_image_url');
      await prefs.reload();
      debugPrint('UserService: Session cleared');
    } catch (e) {
      // If clearing fails, continue
      debugPrint('UserService: Error clearing session: $e');
    }
  }

  // Extract name from email (e.g., "john.doe@example.com" -> "John Doe")
  String _extractNameFromEmail(String email) {
    final emailPart = email.split('@')[0];
    final parts = emailPart.split('.');
    if (parts.length > 1) {
      return parts
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join(' ');
    }
    return emailPart[0].toUpperCase() + emailPart.substring(1);
  }

  // Get user's display name
  String getDisplayName() {
    if (_currentUser == null) return 'Guest';
    return _currentUser!['name'] ?? 'User';
  }

  // Get user's email
  String getEmail() {
    if (_currentUser == null) return '';
    return _currentUser!['email'] ?? '';
  }

  // Get user's profile image URL
  String? getProfileImageUrl() {
    if (_currentUser == null) return null;
    return _currentUser!['profileImageUrl'];
  }

  // Get user's initial for avatar
  String getInitial() {
    final name = getDisplayName();
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    await clearSession();
    // Also sign out from Firebase
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('UserService: Signed out from Firebase');
    } catch (e) {
      debugPrint('UserService: Error signing out from Firebase: $e');
    }
  }
}

