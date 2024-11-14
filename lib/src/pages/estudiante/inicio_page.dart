import 'package:app_movil/src/pages/estudiante/trivia_page.dart';
import 'package:flutter/material.dart';

import 'package:app_movil/src/pages/estudiante/comunicado_page.dart';
import 'package:app_movil/src/pages/estudiante/perfil_page.dart';
import 'package:app_movil/src/pages/estudiante/tarea_page.dart';
import 'package:app_movil/src/services/publicacion_services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioPageEst extends ConsumerStatefulWidget {
  const InicioPageEst({super.key});

  @override
  InicioPageEstState createState() => InicioPageEstState();
}

class InicioPageEstState extends ConsumerState<InicioPageEst> {
  final GlobalKey<TareaPageEstState> _tareaPageKey =
      GlobalKey<TareaPageEstState>();
  final GlobalKey<ComunicadoPageEstState> _comunicadoPageKey =
      GlobalKey<ComunicadoPageEstState>();
  final GlobalKey<PerfilPageEstState> _perfilPageKey =
      GlobalKey<PerfilPageEstState>();
  final GlobalKey<TriviaPageState> _triviaPageKey =
      GlobalKey<TriviaPageState>();
  String? username;
  SharedPreferences? _prefs;
  int index = 1;
  bool isLoading = false;
  final PublicacionService pubs = PublicacionService();
  final items = [
    const Icon(
      Icons.campaign,
      size: 30,
    ),
    const Icon(Icons.auto_stories, size: 30),
    LottieBuilder.asset(
      'assets/images/game.json',
      height: 30,
      width: 30,
    ),
    const Icon(CupertinoIcons.person_fill, size: 30),
  ];
  late List<Widget> pages;
  static const titulos = ['COMUNICADOS', 'MIS TAREAS', 'TRIVIA', 'PERFIL'];
  @override
  void initState() {
    cargarPrefs();
    super.initState();
    pages = [
      ComunicadoPageEst(key: _comunicadoPageKey),
      TareaPageEst(key: _tareaPageKey),
      TriviaPage(
        key: _triviaPageKey,
      ),
      PerfilPageEst(
        key: _perfilPageKey,
      ),
    ];
  }

  Future<void> cargarPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      username = _prefs!.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _navigationBar(),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: Text(
            titulos[index],
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                fontSize: 24,
                color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            isLoading
                ? Container(
                    margin: EdgeInsets.only(right: 6),
                    child: const SpinKitSpinningLines(
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : IconButton(
                    onPressed: _accionIconButton,
                    icon: const Icon(
                      Icons.refresh_sharp,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        body: SafeArea(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: pages[index]),
        ));
  }

  Future<void> _accionIconButton() async {
    setState(() {
      isLoading = true; // Mostrar loading al iniciar
    });
    switch (index) {
      case 0:
        await Future.delayed(const Duration(milliseconds: 1800));
        await _comunicadoPageKey.currentState?.refrescarPagina();
        break;
      case 1:
        await Future.delayed(const Duration(milliseconds: 1800));
        await _tareaPageKey.currentState?.refrescarPagina();
        break;
      case 3:
        await Future.delayed(const Duration(milliseconds: 1800));
        await _perfilPageKey.currentState?.refrescarPagina();
        break;
      case 2:
        await Future.delayed(const Duration(milliseconds: 1800));
        await _triviaPageKey.currentState?.refrescarPagina();
        break;
      default:
        print("Índice desconocido");
    }
    setState(() {
      isLoading = false; // Ocultar loading al terminar
    });
  }

  CurvedNavigationBar _navigationBar() {
    return CurvedNavigationBar(
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      color: Colors.blue.shade400,
      buttonBackgroundColor: Colors.white,
      height: 60,
      items: items,
      index: index,
      onTap: (selectedIndex) {
        setState(() {
          index = selectedIndex;
        });
      },
    );
  }
}
