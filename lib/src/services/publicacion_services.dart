import 'package:app_movil/src/models/publicacion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicacionService {
  final Dio _dio = Dio();

  final String? _baseUrl = dotenv.env['HOST'];

  Future<Map<String, dynamic>> publicaciones() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/publicacion',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la petición');
    }
  }

  Future<Map<String, dynamic>> visualizar(
      {required int userId, required int publicacionId}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/visualizacion',
        data: {'user_id': userId, 'publicacion_id': publicacionId},
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la petición');
    }
  }
}

final publicacionProvider = StateProvider<List<Publicacion>>((ref) {
  return [];
});
