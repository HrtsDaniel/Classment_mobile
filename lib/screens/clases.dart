import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:classment_mobile/models/class_model.dart';
import 'package:intl/intl.dart';

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
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final classes = await ApiService.getClassesByCourseId(widget.courseId);
      setState(() {
        _classesFuture = Future.value(classes);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          
          // Contenido principal
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

                        // Manejo de estados
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
                                    return ClassCard(clase: clase);
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

  const ClassCard({super.key, required this.clase});

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
                onPressed: () {
                  
                },
                child: Text(
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