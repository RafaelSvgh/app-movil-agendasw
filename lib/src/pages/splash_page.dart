import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_movil/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LottieBuilder.asset('assets/images/img1.json'),
            ),
          ],
        ),
        duration: 1280,
        backgroundColor: const Color.fromARGB(255, 110, 188, 255),
        splashIconSize: MediaQuery.of(context).size.width,
        nextScreen: const LoginPage());
  }
}
