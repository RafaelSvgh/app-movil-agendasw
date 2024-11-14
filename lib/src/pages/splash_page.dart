import 'package:flutter/material.dart';

import 'package:app_movil/src/pages/tutor/inicio_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_movil/src/models/user.dart';
import 'package:app_movil/src/pages/estudiante/inicio_page.dart';
import 'package:app_movil/src/pages/login_page.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends ConsumerState<SplashPage> {
  bool existenPrefs = true;
  String rol = '';
  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String session = prefs.getString('session') ?? '';
    String username = prefs.getString('username') ?? '';
    String role = prefs.getString('role') ?? '';
    String name = prefs.getString('name') ?? '';
    int uid = prefs.getInt('uid') ?? 0;
    int edad = prefs.getInt('edad') ?? 0;
    setState(() {
      rol = prefs.getString('rol') ?? '';
    });
    setState(() {
      existenPrefs = session != '' && name != '' && username != '' && uid != 0;
    });
    if (existenPrefs) {
      User user = User(
          sessionId: session,
          uid: uid,
          name: name,
          username: username,
          edad: edad,
          role: role);
      ref.read(userProvider.notifier).update((value) => user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.asset('assets/images/img2.json'),
          ),
        ],
      ),
      duration: 1200,
      backgroundColor: const Color.fromARGB(255, 119, 192, 255),
      nextScreen: getNextPage(),
      splashIconSize: MediaQuery.of(context).size.width,
    );
  }

  Widget getNextPage() {
    if (existenPrefs) {
      if (rol == 'tutor') {
        return const InicioPageTut();
      }
      if (rol == 'estudiante') {
        return const InicioPageEst();
      }
    }
    return const LoginPage();
  }
}
