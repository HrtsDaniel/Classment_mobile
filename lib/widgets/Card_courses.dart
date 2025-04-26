import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursesSection extends StatefulWidget {
  const CoursesSection({super.key});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Defensa Personal',
      'description': 'Programa de defensa personal para mejorar tu resistencia',
      'price': '500.000',
      'isPopular': false,
    },
    {
      'title': 'Zumba', 
      'description': 'Clases de entrenamiento funcional para mejorar tu rendimiento físico',
      'price': '600.000',
      'isPopular': false,
    },
    {
      'title': 'Boxeo Avanzado',
      'description': 'Técnicas profesionales de combate y defensa personal',
      'price': '150.000',
      'isPopular': false,
    },
    {
      'title': 'Taekwondo',
      'description': 'Curso de taekwondo para principiantes',
      'price': '500.000',
      'isPopular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Cursos destacados",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SlideTransition(
            position: _slideAnimation,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: (courses.length / 2).ceil(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, pairIndex) {
                final firstIndex = pairIndex * 2;
                final secondIndex = firstIndex + 1;
                
                return Row(
                  children: [
                    Expanded(
                      child: CourseCard(
                        title: courses[firstIndex]['title'],
                        description: courses[firstIndex]['description'],
                        price: courses[firstIndex]['price'],
                        isPopular: courses[firstIndex]['isPopular'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (secondIndex < courses.length)
                      Expanded(
                        child: CourseCard(
                          title: courses[secondIndex]['title'],
                          description: courses[secondIndex]['description'],
                          price: courses[secondIndex]['price'],
                          isPopular: courses[secondIndex]['isPopular'],
                        ),
                      ),
                    if (secondIndex >= courses.length) const Expanded(child: SizedBox()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final bool isPopular;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.isPopular = false,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _starController;
  late Animation<double> _starAnimation;
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _starAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _starController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          tween: Tween<double>(begin: _scale, end: _scale),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: _isHovered 
                    ? Colors.yellow.withOpacity(0.5) 
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                        color: Colors.yellow[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: GoogleFonts.lato(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money_outlined,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.price,
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(_isHovered ? 1.05 : 1.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/cursos');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHovered
                                ? Colors.yellow[700]
                                : Colors.yellow[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                          ),
                          child: Text(
                            "Ver curso",
                            style: GoogleFonts.roboto(
                              color: _isHovered ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.isPopular)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ScaleTransition(
                      scale: _starAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}