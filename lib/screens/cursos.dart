import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:classment_mobile/models/curso_model.dart';

class CursosScreen extends StatefulWidget {
  const CursosScreen({super.key});

  @override
  State<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends State<CursosScreen> {
  late Future<List<Course>> _cursosFuture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCursos();
  }

  Future<void> _fetchCursos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cursos = await ApiService.getCursos();
      setState(() {
        _cursosFuture = Future.value(cursos);
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
                  onRefresh: _fetchCursos,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24)
                        .copyWith(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'NUESTROS CURSOS',
                          style: GoogleFonts.montserrat(
                            color: Colors.yellow.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Descubre nuestra oferta\nde formación deportiva',
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
                                  onPressed: _fetchCursos,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        else
                          FutureBuilder<List<Course>>(
                            future: _cursosFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isWide = constraints.maxWidth > 600;
                                    return Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      alignment: WrapAlignment.center,
                                      children: snapshot.data!.map((curso) {
                                        return SizedBox(
                                          width: isWide
                                              ? constraints.maxWidth / 2 - 20
                                              : double.infinity,
                                          child: CourseCard(curso: curso),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
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

class CourseCard extends StatefulWidget {
  final Course curso;
  const CourseCard({super.key, required this.curso});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  String? _schoolName;
  bool _loadingSchool = false;

  @override
  void initState() {
    super.initState();
    _fetchSchoolName();
  }

  Future<void> _fetchSchoolName() async {
  print('Obteniendo escuela para el curso con ID: ${widget.curso.courseId}');
  setState(() => _loadingSchool = true);
  
  try {
    final escuela = await ApiService.getSchoolNameByCourseId(widget.curso.courseId);
    setState(() {
      _schoolName = escuela.schoolName;
      _loadingSchool = false;
    });
  } catch (e) {
    print('Error al obtener escuela: $e');
    setState(() {
      _schoolName = 'Desconocida';
      _loadingSchool = false;
    });
  }
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'assets${widget.curso.courseImage}',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey[800],
                child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white)),
              ),
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
                        widget.curso.courseName,
                        style: GoogleFonts.montserrat(
                          color: Colors.yellow.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${widget.curso.coursePrice.toStringAsFixed(2)}',
                      style: GoogleFonts.montserrat(
                        color: Colors.green[400],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Nueva fila para el nombre de la escuela
                if (_schoolName != null || _loadingSchool)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.school_outlined,
                            color: Colors.yellow, size: 16),
                        const SizedBox(width: 6),
                        _loadingSchool
                            ? const SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  color: Colors.yellow,
                                  backgroundColor: Colors.grey,
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  _schoolName ?? '',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Edad: ${widget.curso.courseAge}+ años',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.event_seat_outlined,
                        color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Vacantes: ${widget.curso.coursePlaces}',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.curso.courseDescription,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[600],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navegar al detalle del curso
                    },
                    child: Text(
                      'VER DETALLES',
                      style: GoogleFonts.montserrat(
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
