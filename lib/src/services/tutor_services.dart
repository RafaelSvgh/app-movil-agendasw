import 'dart:convert';
import 'package:app_movil/src/models/tutor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class TutorServices {
  final String? baseUrl = dotenv.env['HOST'];

  Future<Map<String, dynamic>> tutor({required int userId}) async {
    final url = Uri.parse('$baseUrl/tutor/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['tutor'];
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la petición');
    }
  }
}

final tutorProvider = StateProvider<Tutor>((ref) {
  return Tutor();
});
