import 'package:flutter/material.dart';
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
    final token = await ApiService.loginUser(email, password);

    if (token != null) {
      final userData = await ApiService.validarToken(token);
      if (userData != null) {
        _user = User.fromJson(userData['user']);
        _token = token;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
