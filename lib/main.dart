import 'package:classment_mobile/screens/auth/login.dart';
import 'package:classment_mobile/screens/auth/register.dart';
import 'package:classment_mobile/screens/escuelas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'controllers/user_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/escuelas': (context) => const Escuelas(),
      },
    );
  }
}
