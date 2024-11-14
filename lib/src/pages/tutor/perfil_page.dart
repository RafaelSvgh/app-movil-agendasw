import 'package:app_movil/src/models/curso.dart';
import 'package:app_movil/src/models/tutor.dart';
import 'package:app_movil/src/services/tutor_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_movil/src/pages/splash_page.dart';
import 'package:app_movil/src/services/curso_services.dart';
import 'package:app_movil/src/services/estudiante_services.dart';
import 'package:app_movil/src/services/materia_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPageTut extends ConsumerStatefulWidget {
  const PerfilPageTut({super.key});

  @override
  PerfilPageTutState createState() => PerfilPageTutState();
}

class PerfilPageTutState extends ConsumerState<PerfilPageTut> {
  EstudianteServices estudianteServices = EstudianteServices();
  CursoServices cursoServices = CursoServices();
  MateriaServices materiaServices = MateriaServices();
  TutorServices tutorServices = TutorServices();
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
    final user = ref.watch(userProvider);
    final response = await tutorServices.tutor(userId: user.uid);
    final response2 = await cursoServices.cursos();
    Cursos cursos = Cursos.fromJson(response2);
    Tutor tutor = Tutor.fromJson(response);
    ref.read(tutorProvider.notifier).update((state) => tutor);
    ref.read(cursosProvider.notifier).update((state) => cursos);
  }

  Future<void> refrescarPagina() async {
    await getDatos();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final tutor = ref.watch(tutorProvider);
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
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Text(
                      'Tutor',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey.shade200,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 300,
                      margin: const EdgeInsets.only(top: 200),
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
                            height: 25,
                            endIndent: 5,
                            thickness: 1.5,
                          ),
                          const Text(
                            'Mis Estudiante/s',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const Divider(
                            height: 25,
                            indent: 5,
                            endIndent: 5,
                            thickness: 1.5,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: tutor.estudiantes?.length,
                              itemBuilder: (context, index) {
                                return _listTile(tutor, index);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    _botonCerrarSesion(context),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 90,
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

  ListTile _listTile(Tutor tutor, int index) {
    final cursos = ref.watch(cursosProvider);
    int? id = tutor.estudiantes?[index].id;
    final curso = id != null ? cursos.findCursoByEstudianteId(id) : null;
    return ListTile(
      dense: true,
      leading: const Icon(
        Icons.person_pin_outlined,
        size: 25,
      ),
      onTap: () {},
      title: Text(tutor.estudiantes?[index].name ?? '...'),
      subtitle: Text(
        curso?.displayName ?? '...',
        style: const TextStyle(fontWeight: FontWeight.w500),
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
