import 'package:flutter/material.dart';

class Escuelas extends StatelessWidget {
  const Escuelas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: const Center(child: Text("Bienvenido a la pantalla de Inicio")),
    );
  }
}
