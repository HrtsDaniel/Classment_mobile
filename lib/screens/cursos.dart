import 'package:flutter/material.dart';

class Cursos extends StatelessWidget {
  const Cursos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: const Center(child: Text("Bienvenido a la pantalla de Inicio")),
    );
  }
}
