import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  AuthProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      _user = UserModel.fromJson(userData);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    if (email == 'demo@indokos.com' && password == 'password') {
      _user = UserModel(
          id: '1', email: email, name: 'Demo User', provider: 'email');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _user!.toJson());
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> loginWithGoogle() async {
    _user = UserModel(
        id: 'google123',
        email: 'demo.google@indokos.com',
        name: 'Google User',
        provider: 'google',
        avatar: 'https://i.pravatar.cc/150?u=google123');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', _user!.toJson());
    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    // In a real app, this would hit an API. Here we just simulate success.
    await Future.delayed(const Duration(seconds: 1));
  }

  // FIX: Added method to update user profile
  Future<bool> updateProfile(String newName, String newEmail) async {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        email: newEmail,
        name: newName,
        provider: _user!.provider,
        avatar: _user!.avatar,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _user!.toJson());
      notifyListeners();
      return true;
    }
    return false;
  }

  // FIX: Added method to change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    // This is a mock implementation. In a real app, you would verify the old password.
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }
}
