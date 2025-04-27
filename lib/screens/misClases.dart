import 'package:classment_mobile/models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisClases extends StatefulWidget {
  const MisClases({super.key});

  @override
  State<MisClases> createState() => _MisClasesState();
}

class _MisClasesState extends State<MisClases> {
  late Future<List<UserEnrollmentInfo>> _inscripcionesFuture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshInscripciones();
  }

  Future<void> _refreshInscripciones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final nuevasInscripciones = await _fetchInscripciones();
      setState(() {
        _inscripcionesFuture = Future.value(nuevasInscripciones);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<UserEnrollmentInfo>> _fetchInscripciones() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        print('Obteniendo inscripciones para el usuario: $userId');
        final inscripciones = await ApiService.getUserEnrollmentsInfo(userId);
        print('Inscripciones obtenidas: $inscripciones');
        return inscripciones;
      } else {
        throw Exception('Usuario no identificado');
      }
    } catch (e) {
      print('Error en _fetchInscripciones: $e');
      throw Exception('Error al obtener las inscripciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Contenido principal
          Column(
            children: [
              const CustomNavbar(height: 80),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchInscripciones,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24)
                        .copyWith(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'MIS CLASES AGENDADAS',
                          style: GoogleFonts.montserrat(
                            color: Colors.yellow.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Revisa tus próximas\nsesiones programadas',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Manejo de estados
                        if (_isLoading)
                          const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.yellow))
                        else if (_error != null)
                          Center(
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 50),
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchInscripciones,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        else
                          FutureBuilder<List<UserEnrollmentInfo>>(
                            future: _inscripcionesFuture,
                            builder: (context, snapshot) {
                              print(
                                  'Estado del FutureBuilder: ${snapshot.connectionState}');
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellow,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                final inscripciones = snapshot.data!;
                                if (inscripciones.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 60, color: Colors.grey),
                                      const SizedBox(height: 20),
                                      Text(
                                        'No tienes clases agendadas',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Agenda tu primera clase',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isWide = constraints.maxWidth > 600;
                                      return Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        alignment: WrapAlignment.center,
                                        children:
                                            inscripciones.map((inscripcion) {
                                          return SizedBox(
                                            width: isWide
                                                ? constraints.maxWidth / 2 - 20
                                                : double.infinity,
                                            child: ClassCard(
                                                inscripcion: inscripcion),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                }
                              } else {
                                // Estado por defecto (por si acaso)
                                return const Center(
                                    child:
                                        Text('No hay información disponible.'));
                              }
                            },
                          ),
                        const SizedBox(height: 30),
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
  final UserEnrollmentInfo inscripcion;
  const ClassCard({super.key, required this.inscripcion});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.yellow.shade700,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      inscripcion.courseName,
                      style: GoogleFonts.montserrat(
                        color: Colors.yellow.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade800.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'PROGRAMADA',
                        style: GoogleFonts.montserrat(
                          color: Colors.green.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.school, color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      inscripcion.schoolName,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        inscripcion.schoolAddress,
                        style: GoogleFonts.roboto(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.yellow.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${inscripcion.startDate.day}/${inscripcion.startDate.month}/${inscripcion.startDate.year}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hora',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${inscripcion.startDate.hour}:${inscripcion.startDate.minute.toString().padLeft(2, '0')} - ${inscripcion.endDate.hour}:${inscripcion.endDate.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para cancelar clase
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade400),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'CANCELAR CLASE',
                      style: GoogleFonts.montserrat(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
