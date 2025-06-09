import 'dart:convert';
import 'package:classment_mobile/models/class_model.dart';
import 'package:classment_mobile/models/curso_model.dart';
import 'package:classment_mobile/models/enrollment_model.dart';
import 'package:classment_mobile/models/school_model.dart';
import 'package:classment_mobile/models/user_model.dart';
import 'package:classment_mobile/models/user_info_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final logger = Logger();

class ApiService {
  static const String _baseUrl = 'http://192.168.0.12:5000';

  // USUARIOS
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosLogin),
      );

      logger
          .i('Respuesta del login (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']?['token']?.toString();

        if (token == null || token.isEmpty) {
          logger.e('Token inválido o ausente');
          return null;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        final user = await validarToken(token);
        if (user != null) {
          await prefs.setString('userId', user.userId ?? '');
          await prefs.setString('user_data', jsonEncode(user.toJson()));
          logger.i('Usuario autenticado: ${user.userEmail}');
          return user;
        }
      } else {
        logger.w('Error en login (${response.statusCode}): ${response.body}');
        throw Exception('Error de autenticación: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error en loginUser', error: e, stackTrace: StackTrace.current);
      rethrow;
    }
    return null;
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

      logger.i(
          'Respuesta validarToken: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['user'] != null) {
          final dataUser = data['user'];

          // Verificación exhaustiva de datos
          if (dataUser['id'] == null) {
            logger.e('El usuario no tiene ID en la respuesta');
            return null;
          }

          final user = User(
            userId: dataUser['id'].toString(), // Asegurar que es string
            userName: dataUser['name'] ?? 'Desconocido',
            userLastname: dataUser['lastname'] ?? 'Desconocido',
            userDocumentType: dataUser['document_type'] ?? 'CC',
            userDocument: dataUser['document'] ?? '',
            userEmail: dataUser['email'] ?? '',
            userPassword: '', // No guardar contraseña
            userPhone: dataUser['phone']?.toString() ?? '',
            userImage: dataUser['image'] ?? '',
            userBirth: dataUser['birthdate'] ?? '',
            userState: dataUser['state']?.toString() ?? 'activo',
            roleId: int.tryParse(dataUser['role']?.toString() ?? '') ?? 1,
          );

          logger.i('Usuario validado: ${user.userId} - ${user.userEmail}');
          return user;
        }
      }

      logger.w(
          'Error validando token (${response.statusCode}): ${response.body}');
      return null;
    } catch (e) {
      logger.e('Error en validarToken',
          error: e, stackTrace: StackTrace.current);
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

  // ESCUELAS
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
          return (data['data'] as List)
              .map((json) => Escuela.fromJson(json))
              .toList();
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

  //CURSOS
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
        } else if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is List) {
          final List<dynamic> cursosData = data['data'];
          return cursosData.map((json) => Course.fromJson(json)).toList();
        } else if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is List) {
          final List<dynamic> cursosData = data['data'];
          return cursosData.map((json) => Course.fromJson(json)).toList();
        } else if (data is Map<String, dynamic> &&
            data.containsKey('courses') &&
            data['courses'] is List) {
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

  static Future<EscuelaCurso> getSchoolNameByCourseId(String courseId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/courses/$courseId/school'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return EscuelaCurso.fromJson(jsonData);
      }
      throw Exception('API returned success: false');
    }
    throw Exception('Error HTTP ${response.statusCode}');
  }

  static Future<List<ClassModel>> getClassesByCourseId(String courseId) async {
    final url = Uri.parse('$_baseUrl/api/classes/course/$courseId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List classesJson = data['data'] ?? [];
        return classesJson.map((json) => ClassModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las clases: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<Enrollment> scheduleClass({
    required String userId,
    required String courseId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No autenticado. Por favor inicie sesión.');
    }

    final url = Uri.parse('$_baseUrl/api/enrollments/schedule-class');
    final requestBody = {
      "user_id": userId,
      "course_id": courseId,
      "start_date": startDate.toUtc().toIso8601String(),
      "end_date": endDate.toUtc().toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true) {
          if (responseData['data'] != null) {
            return Enrollment.fromJson(responseData['data']);
          }
          // Si solo viene el mensaje de éxito
          return Enrollment(
            enrollmentId: '',
            userId: userId,
            courseId: courseId,
            startDate: startDate,
            endDate: endDate,
            status: 'active',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        throw Exception(responseData['message'] ?? 'Error desconocido');
      } else {
        throw Exception(responseData['message'] ?? 'Error al agendar clase');
      }
    } catch (e) {
      logger.e('Error en scheduleClass', error: e);
      rethrow;
    }
  }

  static Future<List<UserEnrollmentInfo>> getUserEnrollmentsInfo(
      String userId) async {
    final url = Uri.parse('$_baseUrl/api/enrollments/user-info/$userId');

    try {
      final response = await http.get(url);

      print(
          'Respuesta de la API: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List enrollmentsJson = data['data'] ?? [];
        print(
            'Datos procesados: $enrollmentsJson');
        return enrollmentsJson
            .map((json) => UserEnrollmentInfo.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Error al obtener inscripciones: Por favor Inscribete a una clase para ver tus proximas clases agendadas');
      }
    } catch (e) {
      print('Error en getUserEnrollmentsInfo: $e');
      rethrow;
    }
  }

  static Future<bool> deleteEnrollment(String enrollmentId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('No autenticado. Por favor inicie sesión.');
  }

  final url = Uri.parse('$_baseUrl/api/enrollments');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'enrollment_id': enrollmentId,
      }),
    );

    print('Respuesta de la API: ${response.body}');

    if (response.statusCode == 200) {
      print('Inscripción eliminada exitosamente');
      return true;
    } else {
      print('Error al eliminar la inscripción: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error en deleteEnrollment: $e');
    return false;
  }
}
}
