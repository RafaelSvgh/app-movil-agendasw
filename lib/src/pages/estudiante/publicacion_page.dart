import 'dart:io';

import 'package:app_movil/src/models/publicacion.dart';
import 'package:app_movil/src/services/ia_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicacionPage extends ConsumerStatefulWidget {
  const PublicacionPage({super.key});

  @override
  PublicacionPageState createState() => PublicacionPageState();
}

class PublicacionPageState extends ConsumerState<PublicacionPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? path = dotenv.env['HOST'];
  String resultadoIA = '';
  bool isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Publicacion pub = args['pub'];

    TextStyle estiloTitulo =
        const TextStyle(fontSize: 19, fontWeight: FontWeight.w600);

    TextStyle estiloTexto = const TextStyle(fontSize: 17);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade400,
        title: Text(
          pub.materia ?? pub.tipopublicacion ?? 'Tarea',
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.4),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await _pickImage();
                print(_image?.parent ?? 'No hay');
              },
              icon: const Icon(
                Icons.add_photo_alternate,
                size: 35,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isLoading = true; // Activa el loading al hacer la solicitud
          });
          try {
            final sugerencias =
                await obtenerSugerencias(pub.titulo!, pub.detalle!);
            setState(() {
              resultadoIA = sugerencias;
            });
          } catch (e) {
            print(e);
          } finally {
            setState(() {
              isLoading =
                  false; // Desactiva el loading cuando la respuesta llega
            });
          }
        },
        child: isLoading
            ? SpinKitFadingCircle(
                color: Colors.grey.shade700,
              )
            : LottieBuilder.asset('assets/images/ia.json'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titulo('  Título:', estiloTitulo),
              _cajaDeTexto(60, pub.titulo ?? '...', estiloTexto),
              _titulo('  Detalle:', estiloTitulo),
              _cajaDeTexto(195, pub.detalle ?? '...', estiloTexto),
              _fecha('  Publicado el:  ', pub.fechaPublicacion ?? '...',
                  estiloTitulo, estiloTexto),
              const SizedBox(
                height: 8,
              ),
              _fecha('  Fecha Límite:  ', pub.fechaActividad ?? '...',
                  estiloTitulo, estiloTexto),
              Divider(
                height: 30,
                color: Colors.grey.shade900,
              ),
              const Center(
                child: Text(
                  'Archivos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              _cajaArchivos(pub),
              const Center(
                child: Text(
                  'Resultados de IA:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 60, top: 10),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade900)),
                child: SelectableText.rich(
                  TextSpan(
                    children: _buildTextWithLinks(resultadoIA),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _cajaArchivos(Publicacion pub) {
    return Container(
      width: double.infinity,
      height: 230,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade900)),
      child: ListView.builder(
        itemCount: pub.multimedia?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return _listTile(pub, index);
        },
      ),
    );
  }

  ListTile _listTile(Publicacion pub, int index) {
    Multimedia archivo = pub.multimedia![index];
    return ListTile(
      title: Text(archivo.nombreArchivo ?? '...'),
      subtitle: const Text(
        'Descargar',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      dense: true,
      leading: const Icon(Icons.check_circle_outline),
      trailing: const Icon(Icons.link),
      onTap: () async {
        final url = Uri.parse('$path${archivo.urlArchivo}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          print('No se puede abrir el enlace');
        }
      },
    );
  }

  Row _fecha(String texto, String fecha, TextStyle estiloTitulo,
      TextStyle estiloTexto) {
    return Row(
      children: [_titulo(texto, estiloTitulo), _titulo(fecha, estiloTexto)],
    );
  }

  Container _cajaDeTexto(double altura, String texto, TextStyle estiloTexto) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: altura,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: Colors.indigo.shade100),
      child: SingleChildScrollView(
        child: Text(
          texto,
          style: estiloTexto,
        ),
      ),
    );
  }

  Widget _titulo(String texto, TextStyle estiloTitulo) {
    return Text(
      texto,
      style: estiloTitulo,
    );
  }

  List<TextSpan> _buildTextWithLinks(String text) {
    final urlPattern = RegExp(r'(https?:\/\/[^\s]+)');
    final matches = urlPattern.allMatches(text);

    int lastMatchEnd = 0;
    List<TextSpan> spans = [];

    for (var match in matches) {
      // Añadir el texto antes del enlace
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      // Añadir el enlace con GestureRecognizer
      final url = match.group(0);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (await canLaunch(url!)) {
              await launch(url);
            } else {
              throw 'No se puede abrir el enlace $url';
            }
          },
      ));

      lastMatchEnd = match.end;
    }

    // Añadir el texto restante
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }
}
