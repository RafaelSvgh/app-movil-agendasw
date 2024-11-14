import 'dart:convert';
import 'package:app_movil/src/models/materia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MateriaServices {
  // URL base de tu servidor
  final String? baseUrl = dotenv.env['HOST'];

  // Método para obtener todos los cursos
  Future<Map<String, dynamic>> materias({required int id}) async {
    final url = Uri.parse('$baseUrl/materias/$id');

    try {
      final response = await http.get(url); // Llamada GET a la URL

      // Verificamos si la respuesta es exitosa
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Retornamos la lista de cursos
      } else {
        throw Exception('Error al obtener los cursos');
      }
    } catch (e) {
      throw Exception('Error en la solicitud');
    }
  }
}

final materiasProvider = StateProvider<List<Materia>>((ref) {
  return [];
});
