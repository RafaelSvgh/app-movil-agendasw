import 'package:app_movil/src/models/curso.dart';
import 'package:app_movil/src/models/estudiante.dart';
import 'package:app_movil/src/models/publicacion.dart';
import 'package:app_movil/src/services/curso_services.dart';
import 'package:app_movil/src/services/estudiante_services.dart';
import 'package:app_movil/src/services/publicacion_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TareaPageEst extends ConsumerStatefulWidget {
  const TareaPageEst({super.key});

  @override
  TareaPageEstState createState() => TareaPageEstState();
}

class TareaPageEstState extends ConsumerState<TareaPageEst> {
  PublicacionService pubs = PublicacionService();
  EstudianteServices estudianteServices = EstudianteServices();
  CursoServices cursoServices = CursoServices();
  @override
  void initState() {
    getPubs();
    super.initState();
  }

  Future<void> getPubs() async {
    final response = await pubs.publicaciones();
    final user = ref.watch(userProvider);
    final est = await estudianteServices.estudiante(userId: user.uid);
    final response2 = await cursoServices.cursos();
    Estudiante estudiante = Estudiante.fromJson(est);
    Cursos cursos = Cursos.fromJson(response2);
    Curso? curso = cursos.findCursoByEstudianteId(estudiante.id);
    Publicaciones publicaciones = Publicaciones.fromJson(response);
    List<Publicacion> pub = filtrarPublicacionesPorTipos(
        publicaciones.datos!, user.name, 'Estudiantes', curso!.id!, ['Tarea']);
    ref.read(publicacionProvider.notifier).update((value) => pub);
    ref.read(estudianteProvider.notifier).update((state) => estudiante);
  }

  Future<void> refrescarPagina() async {
    await getPubs();
  }

  @override
  Widget build(BuildContext context) {
    final pubs = ref.watch(publicacionProvider);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                itemCount: pubs.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listTile(context, index, pubs);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _listTile(BuildContext context, int index, List<Publicacion> pubs) {
    final user = ref.watch(userProvider);
    final visualizado = pubs[index].usuarioEnVisualizaciones(user.name);
    return ListTile(
      title: Text(
        pubs[index].titulo ?? '...',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(pubs[index].materia ?? '...'),
      onTap: () async {
        PublicacionService publicacionService = PublicacionService();
        await publicacionService.visualizar(
            userId: user.uid, publicacionId: pubs[index].id!);

        // Navegar y esperar a que se regrese
        await Navigator.pushNamed(context, 'publicacion',
            arguments: {'pub': pubs[index]});

        // Después de regresar, actualizar las publicaciones
        await getPubs();
      },
      leading: const Icon(
        Icons.edit_note,
        size: 40,
      ),
      iconColor: Colors.grey.shade900,
      trailing: Icon(
        Icons.check_box,
        color: visualizado ? Colors.green : Colors.red,
      ),
    );
  }
}
