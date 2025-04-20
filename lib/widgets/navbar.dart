import 'package:classment_mobile/screens/auth/login.dart';
import 'package:classment_mobile/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNavbar extends StatelessWidget {
  final double height;

  const CustomNavbar({super.key, this.height = 70});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            const Spacer(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Classment Academy",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.grey[900],
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading:
                                  const Icon(Icons.person, color: Colors.white),
                              title: const Text('Perfil',
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Perfil()),
                                );
                              },
                            ),
                            const Divider(color: Colors.white24),
                            ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.white),
                              title: const Text('Cerrar sesión',
                                  style: TextStyle(color: Colors.white)),
                              tileColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('token');
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => LoginUsuario()),
                                  (route) => false,
                                );
                              },
                            )
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
