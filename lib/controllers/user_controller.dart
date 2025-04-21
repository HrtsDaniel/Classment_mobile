import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserController extends ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<bool> registerUser(User userData) async {
    final success = await ApiService.registrarUsuario(userData.toJson());
    return success;
  }

  Future<bool> login(String email, String password) async {
    final user = await ApiService.loginUser(email, password);

    if (user != null) {
      _user = user;
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future loadCurrentUser() async {
    final user = await ApiService.getCurrentUser();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(User updateUser) async {
    final success = await ApiService.updateUserProfile(updateUser);
    if (success) {
      _user = updateUser;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
    _user = null;
    _token = null;
    notifyListeners();
  }
}
