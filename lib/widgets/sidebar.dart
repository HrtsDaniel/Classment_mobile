import 'package:flutter/material.dart';
import 'package:classment_mobile/screens/home.dart';
import 'package:classment_mobile/screens/perfil.dart';
import 'package:classment_mobile/screens/escuelas.dart';
import 'package:classment_mobile/screens/cursos.dart';


class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.home, "text": "INICIO", "page": const HomeScreen()},
    {"icon": Icons.person, "text": "PERFIL", "page": const Perfil()},
    {"icon": Icons.school, "text": "ESCUELAS", "page": const Escuelas()},
    {"icon": Icons.book, "text": "CURSOS", "page": const Cursos()},
    {"icon": Icons.info, "text": "INFORMACIÓN"},
    {"icon": Icons.mail, "text": "CONTACTO"},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Classment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white38,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Tu espacio para crecer en el deporte",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    Navigator.pop(context);

                    if (menuItems[index].containsKey("page")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => menuItems[index]["page"],
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.yellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          menuItems[index]["icon"],
                          color: isSelected ? Colors.black : Colors.white70,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          menuItems[index]["text"],
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
