import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_movil/src/pages/estudiante/inicio_page.dart';
import 'package:app_movil/src/pages/estudiante/perfil_page.dart';
import 'package:app_movil/src/pages/estudiante/publicacion_page.dart';
import 'package:app_movil/src/pages/login_page.dart';
import 'package:app_movil/src/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Electrónica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        useMaterial3: true,
      ),
      initialRoute: 'splash',
      routes: {
        'splash': (BuildContext context) => const SplashPage(),
        'login': (BuildContext context) => const LoginPage(),
        'inicio': (BuildContext context) => const InicioPageEst(),
        'perfil': (BuildContext context) => const PerfilPageEst(),
        'publicacion': (BuildContext context) => const PublicacionPage(),
      },
    );
  }
}
