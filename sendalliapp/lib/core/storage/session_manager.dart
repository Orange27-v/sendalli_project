import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/user_role.dart';

/// Local session and persistence manager for authentication and guest tracking.
class SessionManager {
  static const String _userKey = 'sendalli_active_user';
  static const String _trackingKey = 'sendalli_active_tracking_id';
  static const String _activeRoleKey = 'sendalli_active_role';

  /// Save authenticated user profile to local storage.
  static Future<void> saveUserProfile(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_activeRoleKey, user.role.name);
  }

  /// Retrieve the active user profile, or null if logged out.
  static Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Save guest receiver active tracking ID.
  static Future<void> saveTrackingId(String trackingId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_trackingKey, trackingId);
  }

  /// Retrieve the cached guest tracking ID.
  static Future<String?> getTrackingId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_trackingKey);
  }

  /// Clear guest tracking session once delivery concludes.
  static Future<void> clearTrackingId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_trackingKey);
  }

  /// Switch the active role view (e.g. Sender switching to Hub view).
  static Future<void> switchRole(UserRole newRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRoleKey, newRole.name);
  }

  /// Get current active role view.
  static Future<UserRole?> getActiveRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleName = prefs.getString(_activeRoleKey);
    if (roleName == null) return null;
    try {
      return UserRole.values.byName(roleName);
    } catch (_) {
      return null;
    }
  }

  /// Log out and clear stored session.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_activeRoleKey);
  }
}
