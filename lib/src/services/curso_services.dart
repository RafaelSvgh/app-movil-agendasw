import 'dart:convert';
import 'package:app_movil/src/models/curso.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CursoServices {
  final String? baseUrl = dotenv.env['HOST'];

  Future<Map<String, dynamic>> cursos() async {
    final url = Uri.parse('$baseUrl/cursos');

    try {
      final response = await http.get(url);

      // Verificamos si la respuesta es exitosa
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Retornamos la lista de cursos
      } else {
        throw Exception('Error al obtener los cursos');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      throw Exception('Error en la solicitud');
    }
  }

  Future<Map<String, dynamic>> cursosId({required int id}) async {
    final url = Uri.parse('$baseUrl/cursos/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['curso']; // Retornamos la lista de cursos
      } else {
        throw Exception('Error al obtener los cursos');
      }
    } catch (e) {
      throw Exception('Error en la solicitud');
    }
  }
}

final cursoProvider = StateProvider<Curso>((ref) {
  return Curso();
});

final cursosProvider = StateProvider<Cursos>((ref) {
  return Cursos();
});
