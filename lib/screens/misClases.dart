import 'package:classment_mobile/models/enrollment_model.dart';
import 'package:classment_mobile/models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MisClases extends StatefulWidget {
  const MisClases({super.key});

  @override
  State<MisClases> createState() => _MisClasesState();
}

class _MisClasesState extends State<MisClases> {
  late Future<List<UserEnrollmentInfo>> _inscripcionesFuture;
  bool _isLoading = true;
  bool _isDeletingEnrollment = false;
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
        final inscripciones = await ApiService.getUserEnrollmentsInfo(userId);
        return inscripciones;
      } else {
        throw Exception('Usuario no identificado');
      }
    } catch (e) {
      throw Exception('Error al obtener las inscripciones: $e');
    }
  }

  Future<void> _deleteEnrollment(String enrollmentId) async {
    setState(() {
      _isDeletingEnrollment = true;
    });

    try {
      await ApiService.deleteEnrollment(enrollmentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Clase cancelada exitosamente',
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      await _refreshInscripciones();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'Reintentar',
            textColor: Colors.yellow,
            onPressed: () => _deleteEnrollment(enrollmentId),
          ),
        ),
      );
    } finally {
      setState(() {
        _isDeletingEnrollment = false;
      });
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
                  onRefresh: _refreshInscripciones,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _refreshInscripciones,
                                      child: const Text('Reintentar'),
                                    ),
                                  ],
                                ),
                              )
                            else
                              FutureBuilder<List<UserEnrollmentInfo>>(
                                future: _inscripcionesFuture,
                                builder: (context, snapshot) {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          final isWide =
                                              constraints.maxWidth > 600;
                                          return Wrap(
                                            spacing: 16,
                                            runSpacing: 16,
                                            alignment: WrapAlignment.center,
                                            children: inscripciones
                                                .map((inscripcion) {
                                              return SizedBox(
                                                width: isWide
                                                    ? constraints.maxWidth / 2 -
                                                        20
                                                    : double.infinity,
                                                child: ClassCard(
                                                  inscripcion: inscripcion,
                                                  onDelete: () =>
                                                      _deleteEnrollment(
                                                          inscripcion
                                                              .enrollmentId),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    return const Center(
                                        child: Text(
                                            'No hay información disponible.'));
                                  }
                                },
                              ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      if (_isDeletingEnrollment)
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                    color: Colors.yellow),
                                const SizedBox(height: 16),
                                Text(
                                  'Cancelando clase...',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
  final VoidCallback onDelete;

  const ClassCard({
    super.key,
    required this.inscripcion,
    required this.onDelete,
  });

  bool get canCancel {
    return inscripcion.startDate.isAfter(DateTime.now());
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirmar cancelación',
          style: GoogleFonts.montserrat(
            color: Colors.yellow.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro que deseas cancelar:',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              inscripcion.courseName,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy').format(inscripcion.startDate)}',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            Text(
              'Hora: ${DateFormat('HH:mm').format(inscripcion.startDate)} - ${DateFormat('HH:mm').format(inscripcion.endDate)}',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Volver',
              style: GoogleFonts.montserrat(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              'Confirmar cancelación',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                    Expanded(
                      child: Text(
                        inscripcion.courseName,
                        style: GoogleFonts.montserrat(
                          color: Colors.yellow.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                            DateFormat('dd/MM/yyyy')
                                .format(inscripcion.startDate),
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
                            '${DateFormat('HH:mm').format(inscripcion.startDate)} - ${DateFormat('HH:mm').format(inscripcion.endDate)}',
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
                  child: ElevatedButton.icon(
                    onPressed: canCancel
                        ? () => _showDeleteConfirmation(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canCancel
                          ? Colors.red.shade900.withOpacity(0.7)
                          : Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color: canCancel
                                ? Colors.red.shade400
                                : Colors.grey.shade600,
                            width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Icon(
                      canCancel ? Icons.cancel_outlined : Icons.block,
                      size: 20,
                    ),
                    label: Text(
                      canCancel ? 'Cancelar clase' : 'No cancelable',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
