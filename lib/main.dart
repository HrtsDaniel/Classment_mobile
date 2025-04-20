import 'package:classment_mobile/screens/auth/login.dart';
import 'package:classment_mobile/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      initialRoute: '/',
      routes: {
        '/register': (context) => const RegistroUsuario(),
        '/login': (context) => const LoginUsuario(),
      },
    );
  }
}
