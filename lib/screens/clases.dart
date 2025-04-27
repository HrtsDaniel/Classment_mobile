import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:classment_mobile/models/class_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer; // Para logging detallado

class ClassesScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ClassesScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Future<List<ClassModel>> _classesFuture;
  bool _isLoading = true;
  bool _isEnrolling = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    developer.log('Inicializando ClassesScreen', name: 'ClassesScreen');
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    developer.log('Obteniendo clases para el curso ${widget.courseId}', name: 'ClassesScreen');
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final classes = await ApiService.getClassesByCourseId(widget.courseId);
      developer.log('Clases obtenidas: ${classes.length}', name: 'ClassesScreen');
      
      setState(() {
        _classesFuture = Future.value(classes);
      });
    } catch (e) {
      developer.log('Error al obtener clases: $e', name: 'ClassesScreen', error: e);
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _enrollToClass(BuildContext context, ClassModel classItem) async {
    developer.log('Intentando inscribir a clase: ${classItem.classId}', name: 'ClassesScreen');
    
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    
    developer.log('UserID obtenido de SharedPreferences: $userId', name: 'ClassesScreen');
    
    if (userId == null || userId.isEmpty) {
      developer.log('No se encontró userId válido', name: 'ClassesScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo identificar al usuario. Por favor inicie sesión nuevamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Validar si la clase ya pasó
    if (classItem.classDate.isBefore(DateTime.now())) {
      developer.log('Clase ya pasó: ${classItem.classDate}', name: 'ClassesScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta clase ya ocurrió el ${DateFormat('dd/MM/yyyy').format(classItem.classDate)}'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Calcular fecha de fin
    final endDate = classItem.classDate.add(Duration(minutes: classItem.duration));
    developer.log('Fecha de inicio: ${classItem.classDate}, Fecha de fin: $endDate', name: 'ClassesScreen');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Confirmar inscripción',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curso: ${widget.courseName}',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Clase: ${classItem.classTitle}',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${DateFormat('EEE, d MMM y - hh:mm a').format(classItem.classDate)}',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Duración: ${classItem.duration} minutos',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              developer.log('Inscripción cancelada por el usuario', name: 'ClassesScreen');
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: GoogleFonts.montserrat(color: Colors.yellow[600]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[600],
            ),
            onPressed: () async {
              developer.log('Usuario confirmó inscripción', name: 'ClassesScreen');
              Navigator.pop(context);
              await _processEnrollment(context, userId, classItem, endDate);
            },
            child: Text(
              'Confirmar',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processEnrollment(
  BuildContext context,
  String userId,
  ClassModel classItem,
  DateTime endDate,
) async {
  developer.log('Procesando inscripción...', name: 'ClassesScreen');
  
  setState(() => _isEnrolling = true);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  
  try {
    developer.log('Enviando datos al servidor...', name: 'ClassesScreen');
    
    await ApiService.scheduleClass(
      userId: userId,
      courseId: widget.courseId,
      startDate: classItem.classDate,
      endDate: endDate,
    );

    // Mostrar mensaje de éxito
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Inscripción exitosa'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Actualizar la lista de clases
    await _fetchClasses();
    
  } on Exception catch (e) {
    // Manejar solo si el mensaje no contiene "exitosa"
    if (!e.toString().toLowerCase().contains('exitosa')) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${_getUserFriendlyError(e)}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Si el mensaje contiene "exitosa", mostrarlo como éxito
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('✅ ${e.toString().replaceFirst('Exception: ', '')}'),
          backgroundColor: Colors.green,
        ),
      );
      await _fetchClasses();
    }
  } finally {
    setState(() => _isEnrolling = false);
  }
}

  String _getUserFriendlyError(dynamic error) {
    developer.log('Procesando error: $error', name: 'ClassesScreen');
    
    if (error.toString().contains('No hay token de autenticación')) {
      return 'Su sesión ha expirado. Por favor inicie sesión nuevamente.';
    } else if (error.toString().contains('Error HTTP 409')) {
      return 'Ya está inscrito en esta clase o hay un conflicto de horario.';
    } else if (error.toString().contains('Error HTTP')) {
      return 'Problema de conexión con el servidor. Intente nuevamente.';
    } else if (error.toString().contains('SocketException')) {
      return 'No hay conexión a internet. Verifique su conexión.';
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          Column(
            children: [
              const CustomNavbar(height: 80),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchClasses,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'CLASES DEL CURSO',
                          style: GoogleFonts.montserrat(
                            color: Colors.yellow.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.courseName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_isLoading)
                          const Center(child: CircularProgressIndicator(color: Colors.yellow))
                        else if (_error != null)
                          Center(
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchClasses,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        else
                          FutureBuilder<List<ClassModel>>(
                            future: _classesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No hay clases programadas',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }
                                
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final clase = snapshot.data![index];
                                    return ClassCard(
                                      clase: clase,
                                      onEnroll: () => _enrollToClass(context, clase),
                                      isEnrolling: _isEnrolling,
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final ClassModel clase;
  final VoidCallback onEnroll;
  final bool isEnrolling;

  const ClassCard({
    super.key,
    required this.clase,
    required this.onEnroll,
    required this.isEnrolling,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    clase.classTitle,
                    style: GoogleFonts.montserrat(
                      color: Colors.yellow.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${clase.duration} min',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (clase.classDescription != null && clase.classDescription!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  clase.classDescription!,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Disponibilidad:',
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 4),
                  child: Text(
                    'A partir del ${DateFormat('EEE, d MMM y').format(clase.classDate)} a las ${DateFormat('hh:mm a').format(clase.classDate)}',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: isEnrolling ? null : onEnroll,
                child: isEnrolling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : Text(
                        'Tomar Clase',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}