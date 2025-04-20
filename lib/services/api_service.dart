import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final logger = Logger();

class ApiService {
  static const String _baseUrl = 'http://192.168.0.8:5000';

  static Future<bool> registrarUsuario(
      Map<String, dynamic> datosUsuario) async {
    final url = Uri.parse('$_baseUrl/api/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosUsuario),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        logger.w('Error en respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Error en la solicitud: $e');
      return false;
    }
  }

  static Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/login');

    final Map<String, dynamic> datosLogin = {
      'user': {
        'user_email': email.trim(),
        'user_password': password.trim(),
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(datosLogin),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        logger.i('Token recibido: $token');
        return token;
      } else {
        logger.w('Error en login: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.e('Error en la solicitud: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> validarToken(String token) async {
    final url = Uri.parse('$_baseUrl/api/users/auth/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        logger.w('Token inválido: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.e('Error al validar token: $e');
      return null;
    }
  }
}
