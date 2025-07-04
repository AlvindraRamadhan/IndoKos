import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _loading = true;

  UserModel? get user => _user;
  bool get loading => _loading;

  static const String _userKey = 'indokos_user';

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'email': 'demo@indokos.com',
      'name': 'Demo User',
      'provider': 'email',
      'password': 'password',
      'avatar':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    }
  ];

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_userKey);
    if (savedUser != null) {
      _user = UserModel.fromJson(savedUser);
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final foundUser = _mockUsers.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => {});
      if (foundUser.isNotEmpty) {
        _user = UserModel.fromMap(foundUser);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, _user!.toJson());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (_mockUsers.any((u) => u['email'] == email)) {
        return false;
      }
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        provider: 'email',
        avatar:
            'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      );
      _mockUsers.add({...newUser.toMap(), 'password': password});

      // For demo, we don't auto-login after register to match user flow
      // _user = newUser;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString(_userKey, _user!.toJson());

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final googleUser = UserModel(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user.google@gmail.com',
        name: 'Google User',
        avatar:
            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        provider: 'google',
      );
      _user = googleUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, _user!.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }
}
