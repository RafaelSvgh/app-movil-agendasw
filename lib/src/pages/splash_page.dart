import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_movil/src/models/user.dart';
import 'package:app_movil/src/pages/home_page.dart';
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

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String session = prefs.getString('session') ?? '';
    String username = prefs.getString('username') ?? '';
    String name = prefs.getString('name') ?? '';
    int uid = prefs.getInt('uid') ?? 0;
    setState(() {
      existenPrefs = session != '' && name != '' && username != '' && uid != 0;
    });
    if (existenPrefs) {
      User user =
          User(sessionId: session, uid: uid, name: name, username: username);
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
            child: LottieBuilder.asset('assets/images/img1.json'),
          ),
        ],
      ),
      duration: 1245,
      backgroundColor: const Color.fromARGB(255, 119, 192, 255),
      nextScreen: existenPrefs ? const HomePage() : const LoginPage(),
      splashIconSize: MediaQuery.of(context).size.width,
    );
  }
}
