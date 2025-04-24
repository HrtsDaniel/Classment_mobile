import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classment_mobile/widgets/sidebar.dart';
import 'package:classment_mobile/widgets/navbar.dart';

class Escuelas extends StatelessWidget {
  const Escuelas({super.key});

  final List<Map<String, String>> schools = const [
    {
      'school_name': 'GO FIT',
      'school_description': 'Entrenamiento y acondicionamiento físico.',
      'school_phone': '3124567890',
      'school_address': 'Calle 123, Bogotá D.C',
      'school_email': 'danielbernal.04@gmail.com',
      'school_image':
          'https://images.unsplash.com/photo-1637666133087-23b7138ea721?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {
      'school_name': 'Soy Fitness',
      'school_description': 'Yoga, Pilates y mas',
      'school_phone': '9876543210',
      'school_address': 'Avenida 456, primera de mayo con boyaca',
      'school_email': 'soyfitness@gmail.com',
      'school_image':
          'https://media.istockphoto.com/id/1399212293/es/foto/clase-de-educaci%C3%B3n-f%C3%ADsica-y-entrenamiento-deportivo-en-bachillerato.jpg?s=612x612&w=0&k=20&c=3Q_1fKedbs-IQhtUNihpLox8OO_OCTLWrpQy39eH8gM=',
    },
    {
      'school_name': 'Taekwondo',
      'school_description': 'Cursos de taekwondo para todos los niveles',
      'school_phone': '5555555555',
      'school_address': 'Plaza Principal, Carrera 10 con circunvalar',
      'school_email': 'taekwondo@gmail.com',
      'school_image':
          'https://media.istockphoto.com/id/1077629152/es/foto/hombre-y-mujer-taekwondo-combate.jpg?s=612x612&w=0&k=20&c=KEFFGcANJfl1G8OVzJ0HpqhNxlCJfC98ESjeuS7UeV8=',
    },
  ];

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

                      // Lista de escuelas
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 600;
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: schools.map((school) {
                              return SizedBox(
                                width: isWide ? constraints.maxWidth / 2 - 20 : double.infinity,
                                child: SchoolCard(school: school),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
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

class SchoolCard extends StatelessWidget {
  final Map<String, String> school;
  const SchoolCard({super.key, required this.school});

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
            child: Image.network(
              school['school_image']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school['school_name']!,
                  style: GoogleFonts.montserrat(
                    color: Colors.yellow.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  school['school_description']!,
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
                      school['school_phone']!,
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
                        school['school_address']!,
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
                        school['school_email']!,
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