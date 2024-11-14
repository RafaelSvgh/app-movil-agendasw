import 'dart:convert';
import 'package:app_movil/src/models/estudiante.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class EstudianteServices {
  final String? baseUrl = dotenv.env['HOST'];

  Future<Map<String, dynamic>> estudiante({required int userId}) async {
    final url = Uri.parse('$baseUrl/estudiante/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['estudiante'];
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la petición');
    }
  }

  Future<void> actualizarPuntos({required int id, required int puntos}) async {
    final url = Uri.parse('$baseUrl/estudiante/actualizar');
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'puntos': puntos,
          'id': id,
        }),
      );
    } catch (e) {
      throw Exception('Error durante la petición: $e');
    }
  }

  Future<Map<String, dynamic>> topEstudiantes() async {
    final url = Uri.parse('$baseUrl/estudiantes/top');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la petición: $e');
    }
  }
}

final estudianteProvider = StateProvider<Estudiante>((ref) {
  return Estudiante(id: 0, name: 'name', puntos: 0);
});

final estudiantesProvider = StateProvider<Estudiantes>((ref) {
  return Estudiantes(status: '', estudiantes: []);
});
