import 'dart:convert';
import 'package:classment_mobile/models/curso_model.dart';
import 'package:classment_mobile/models/school_model.dart';
import 'package:classment_mobile/models/user_model.dart';
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

  static Future<User?> loginUser(String email, String password) async {
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
        logger.i('Respuesta del login: $data');

        final token = data['data']?['token']?.toString();

        if (token == null || token.isEmpty) {
          logger.e('Token inválido o ausente: $token');
          return null;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        final user = await validarToken(token);
        if (user != null) {
          await prefs.setString('user_data', jsonEncode(user.toJson()));
          return user;
        }
      } else {
        logger.w(
            'Error en respuesta login (${response.statusCode}): ${response.body}');
      }
      return null;
    } catch (e) {
      logger.e('Error en el login: $e');
      return null;
    }
  }

  static Future<User?> validarToken(String? token) async {
    final url = Uri.parse('$_baseUrl/api/auth/me');

    if (token == null) {
      logger.i('Token es nulo en validarToken');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      logger.i('Respuesta validarToken e informacion: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['user'] != null) {
          final dataUser = data['user'];

          User user = User(
            userId: dataUser['id'] ?? '',
            userName: dataUser['name'] ?? 'Desconocido',
            userLastname: dataUser['lastname'] ?? 'Desconocido',
            userDocumentType: 'CC',
            userDocument: dataUser['document'] ?? '',
            userEmail: dataUser['email'] ?? '',
            userPassword: '',
            userPhone: dataUser['phone'] ?? '',
            userImage: dataUser['image'] ?? '',
            userBirth: dataUser['birthdate'] ?? '',
            userState: 'activo',
            roleId: dataUser['role'] ?? 1,
          );
          return user;
        }
      }
      logger.w(
          'Error validando token (${response.statusCode}): ${response.body}');
      return null;
    } catch (e) {
      logger.e('Error en validarToken: $e');
      return null;
    }
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      try {
        return User.fromJson(jsonDecode(userDataString));
      } catch (e) {
        logger.e('Error parseando user_data: $e');
        return null;
      }
    }
    return null;
  }

  static Future<bool> updateUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/api/users/${user.userId}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'applicattion/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_name': user.userName,
          'user_lastname': user.userLastname,
          'user_phone': user.userPhone,
          'user_email': user.userEmail,
          'user_image': user.userImage
        }),
      );
      if (response.statusCode == 200) {
        await prefs.setString('user_data', jsonEncode(user.toJson()));
        return true;
      }
      logger.w(
          'Error actualizando perfil (${response.statusCode}): ${response.body}');
      return false;
    } catch (e) {
      logger.e('Error en updateUserProfile: $e');
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final currentUser = await getCurrentUser();

    if (token == null || currentUser == null) {
      logger.e('No hay token o usuario para desactivar la cuenta');
      return false;
    }
    final url = Uri.parse('$_baseUrl/api/users/${currentUser.userId}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user': {
            'user_state': 'inactivo',
          }
        }),
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('user_data');
        logger.i('Cuenta eliminada exitosamente');
        return true;
      } else {
        logger.w(
            'Error eliminando cuenta (${response.statusCode}): ${response.body}');
        return false;
      }
    } catch (e) {
      logger.e('Error en deleteAccount: $e');
      return false;
    }
  }

 static Future<List<Escuela>> getEscuelas() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  
  if (token == null) {
    throw 'No hay token de autenticación. Por favor inicie sesión.';
  }

  final url = Uri.parse('$_baseUrl/api/schools');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    logger.i('Respuesta de /api/schools: ${response.statusCode}');
    logger.v('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data is List) {
        return data.map((json) => Escuela.fromJson(json)).toList();
      }
      
      if (data is Map && data['data'] is List) {
        return (data['data'] as List).map((json) => Escuela.fromJson(json)).toList();
      }
      
      throw 'Formato de respuesta no reconocido';
    } else if (response.statusCode == 401) {
      throw 'Sesión expirada. Por favor vuelva a iniciar sesión.';
    } else {
      throw 'Error al cargar escuelas: ${response.statusCode}';
    }
  } catch (e) {
    logger.e('Error en getEscuelas', error: e);
    rethrow;
  }
 }

 static Future<List<Course>> getCursos() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  
  if (token == null) {
    throw 'No hay token de autenticación. Por favor inicie sesión.';
  }

  final url = Uri.parse('$_baseUrl/api/courses');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    logger.i('Respuesta de /api/courses: ${response.statusCode}');
    logger.v('Body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      
      if (data is List) {
        return data.map((json) => Course.fromJson(json)).toList();
      }
      
      else if (data is Map<String, dynamic> && data.containsKey('data') && data['data'] is List) {
        final List<dynamic> cursosData = data['data'];
        return cursosData.map((json) => Course.fromJson(json)).toList();
      }
      else if (data is Map<String, dynamic> && data.containsKey('data') && data['data'] is List) {
        final List<dynamic> cursosData = data['data'];
        return cursosData.map((json) => Course.fromJson(json)).toList();
      }
      
      else if (data is Map<String, dynamic> && data.containsKey('courses') && data['courses'] is List) {
        final List<dynamic> cursosData = data['courses'];
        return cursosData.map((json) => Course.fromJson(json)).toList();
      }
      
      logger.e('Estructura de respuesta no reconocida: $data');
      throw 'Formato de respuesta no reconocido para cursos';
    } else if (response.statusCode == 401) {
      throw 'Sesión expirada. Por favor vuelva a iniciar sesión.';
    } else {
      throw 'Error al cargar cursos: ${response.statusCode}';
    }
  } catch (e) {
    logger.e('Error en getCursos', error: e);
    rethrow;
  }
}
  static Future<Escuela> getEscuelaById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/escuelas/$id'));
    if (response.statusCode == 200) {
      return Escuela.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load escuela');
    }
  }
}
