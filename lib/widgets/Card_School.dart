import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedSchoolsSection extends StatefulWidget {
  const FeaturedSchoolsSection({super.key});

  @override
  State<FeaturedSchoolsSection> createState() => _FeaturedSchoolsSectionState();
}

class _FeaturedSchoolsSectionState extends State<FeaturedSchoolsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
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
              "Escuelas destacadas",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(width: 8),
                SlideTransition(
                  position: _slideAnimation,
                  child: const SchoolCard(
                    name: "GO FIT",
                    description: "Entrenamiento y acondicionamiento físico",
                    address: "Calle 123, Bogotá D.C",
                  ),
                ),
                const SizedBox(width: 16),
                SlideTransition(
                  position: _slideAnimation,
                  child: const SchoolCard(
                    name: "Soy Fitness",
                    description: "Yoga, Pilates y más",
                    address: "Avenida 456, primera de mayo con boyaca",
                  ),
                ),
                const SizedBox(width: 16),
                SlideTransition(
                  position: _slideAnimation,
                  child: const SchoolCard(
                    name: "Taekwondo",
                    description: "Cursos de taekwondo para todos los niveles",
                    address: "Plaza Principal, Carrera 10 con cincunvalar",
                    isFavorite: true,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SchoolCard extends StatefulWidget {
  final String name;
  final String description;
  final String address;
  final bool isFavorite;

  const SchoolCard({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    this.isFavorite = false,
  });

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _heartAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
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
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.yellow[600],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Dirección: ${widget.address}",
                              style: GoogleFonts.lato(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción para ver la escuela
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isHovered 
                                  ? Colors.yellow[700] 
                                  : Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              "Ver Escuela",
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
                ),
                if (widget.isFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ScaleTransition(
                      scale: _heartAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
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