import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String? username;
  SharedPreferences? _prefs;
  @override
  void initState() {
    cargarPrefs();
    super.initState();
  }

  Future<void> cargarPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      username = _prefs!.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Column(
        children: [
          Text(user.name),
          Text(user.username),
          Text(user.sessionId),
          Text(user.uid.toString()),
          Text(username ?? 'no-email'),
        ],
      ),
    );
  }
}
