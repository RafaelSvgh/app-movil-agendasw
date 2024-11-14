import 'package:app_movil/src/models/publicacion.dart';
import 'package:app_movil/src/services/publicacion_services.dart';
import 'package:app_movil/src/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComunicadoPageTut extends ConsumerStatefulWidget {
  const ComunicadoPageTut({super.key});

  @override
  ComunicadoPageTutState createState() => ComunicadoPageTutState();
}

class ComunicadoPageTutState extends ConsumerState<ComunicadoPageTut> {
  PublicacionService pubs = PublicacionService();
  @override
  void initState() {
    getPubs();
    super.initState();
  }

  Future<void> getPubs() async {
    final response = await pubs.publicaciones();
    final user = ref.watch(userProvider);
    Publicaciones publicaciones = Publicaciones.fromJson(response);
    List<Publicacion> pub = filtrarPublicacionesPorTipos(publicaciones.datos!,
        user.name, 'Tutores', 10000, ['Comunicado', 'Actividad']);
    ref.read(publicacionProvider.notifier).update((value) => pub);
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
        subtitle: Text(pubs[index].tipopublicacion ?? '...'),
        onTap: () async {
          PublicacionService publicacionService = PublicacionService();
          await publicacionService.visualizar(
              userId: user.uid, publicacionId: pubs[index].id!);
          await Navigator.pushNamed(context, 'publicacion',
              arguments: {'pub': pubs[index]});
          await getPubs();
        },
        leading: const Icon(
          Icons.campaign_outlined,
          size: 40,
        ),
        iconColor: Colors.grey.shade900,
        trailing: !visualizado
            ? const Icon(
                Icons.mark_unread_chat_alt,
                color: Colors.red,
                size: 28,
              )
            : Icon(
                Icons.chat,
                size: 28,
                color: Colors.grey.shade800,
              ));
  }
}
