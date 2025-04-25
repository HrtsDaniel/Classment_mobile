import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';
import 'package:classment_mobile/services/api_service.dart';
import 'package:classment_mobile/models/school_model.dart';

class Escuelas extends StatefulWidget {
  const Escuelas({super.key});

  @override
  State<Escuelas> createState() => _EscuelasState();
}

class _EscuelasState extends State<Escuelas> {
  late Future<List<Escuela>> _escuelasFuture;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchEscuelas();
  }

  Future<void> _fetchEscuelas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final escuelas = await ApiService.getEscuelas();
      setState(() {
        _escuelasFuture = Future.value(escuelas);
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
                  onRefresh: _fetchEscuelas,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'NUESTRAS ESCUELAS',
                          style: GoogleFonts.montserrat(
                            color: Colors.yellow.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Explora centros de formación\ndeportiva destacados',
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
                                  onPressed: _fetchEscuelas,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        else
                          FutureBuilder<List<Escuela>>(
                            future: _escuelasFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isWide = constraints.maxWidth > 600;
                                    return Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      alignment: WrapAlignment.center,
                                      children: snapshot.data!.map((escuela) {
                                        return SizedBox(
                                          width: isWide ? constraints.maxWidth / 2 - 20 : double.infinity,
                                          child: SchoolCard(escuela: escuela),
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

class SchoolCard extends StatelessWidget {
  final Escuela escuela;
  const SchoolCard({super.key, required this.escuela});

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
              'assets${escuela.schoolImage}',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey[800],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  escuela.schoolName,
                  style: GoogleFonts.montserrat(
                    color: Colors.yellow.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  escuela.schoolDescription,
                  style: GoogleFonts.lato(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      escuela.schoolPhone,
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        escuela.schoolAddress,
                        style: GoogleFonts.roboto(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        escuela.schoolEmail,
                        style: GoogleFonts.roboto(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}