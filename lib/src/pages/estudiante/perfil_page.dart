import 'package:app_movil/src/models/curso.dart';
import 'package:app_movil/src/models/estudiante.dart';
import 'package:app_movil/src/models/materia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_movil/src/pages/splash_page.dart';
import 'package:app_movil/src/services/curso_services.dart';
import 'package:app_movil/src/services/estudiante_services.dart';
import 'package:app_movil/src/services/materia_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPageEst extends ConsumerStatefulWidget {
  const PerfilPageEst({super.key});

  @override
  PerfilPageEstState createState() => PerfilPageEstState();
}

class PerfilPageEstState extends ConsumerState<PerfilPageEst> {
  EstudianteServices estudianteServices = EstudianteServices();
  CursoServices cursoServices = CursoServices();
  MateriaServices materiaServices = MateriaServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getDatos();
  }

  Future<void> getDatos() async {
    final response = await cursoServices.cursos();
    Cursos cursos = Cursos.fromJson(response);
    final user = ref.watch(userProvider);
    final est = await estudianteServices.estudiante(userId: user.uid);
    Estudiante estudiante = Estudiante.fromJson(est);
    Curso? curso = cursos.findCursoByEstudianteId(estudiante.id);
    final response2 = await materiaServices.materias(id: curso!.id!);
    Materias materias = Materias.fromJson(response2);

    final top = await estudianteServices.topEstudiantes();
    print("Raw top estudiantes response: $top");

    Estudiantes estudiantesTop = Estudiantes.fromJson(top);
    print("Parsed estudiantesTop: ${estudiantesTop.estudiantes}");

    if (mounted) {
      ref.read(cursoProvider.notifier).update((state) => curso);
      ref.read(materiasProvider.notifier).update((state) => materias.materias!);
      ref.read(estudianteProvider.notifier).update((state) => estudiante);
      ref.read(estudiantesProvider.notifier).update((state) => estudiantesTop);
    }
  }

  Future<void> refrescarPagina() async {
    await getDatos();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final materias = ref.watch(materiasProvider);
    final curso = ref.watch(cursoProvider);
    final estudiantesTop = ref.watch(estudiantesProvider);
    const boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 0, 73, 132),
          Color.fromARGB(255, 123, 196, 255)
        ],
        begin: FractionalOffset.bottomCenter,
        end: FractionalOffset.topCenter,
      ),
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: boxDecoration,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1.2,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      'Estudiante',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey.shade200,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 280,
                      margin: const EdgeInsets.only(top: 190),
                      padding:
                          const EdgeInsets.only(top: 20, left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Text(
                            user.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 19,
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                            thickness: 1.5,
                          ),
                          Text(
                            curso.displayName ?? '...',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                            thickness: 1.5,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: materias.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                  ),
                                  title: Text(materias[index].name ?? '...'),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 280,
                      margin: const EdgeInsets.only(top: 5, bottom: 25),
                      padding:
                          const EdgeInsets.only(top: 20, left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Text(
                            'Ranking de Jugadores',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 19,
                                fontWeight: FontWeight.w600),
                          ),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                            thickness: 1.5,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: estudiantesTop.estudiantes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  leading: Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  title: Text(
                                    estudiantesTop.estudiantes[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: Text(
                                    estudiantesTop.estudiantes[index].puntos
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    _botonCerrarSesion(context),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 70,
                child: Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.network(
                        'https://img.freepik.com/vector-gratis/avatar-personaje-empresario-aislado_24877-60111.jpg?t=st=1731102200~exp=1731105800~hmac=c6d354980de6766b1ef21b75de62f81eff663a51084fb09dd02ba29c44e2dc08&w=1380'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _botonCerrarSesion(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                '¿Desea cerrar la sesión actual?',
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: const Text('Sí'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Cerrar Sesión',
        style: TextStyle(
            fontSize: 18,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
