import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final Dio _dio = Dio();

  final String? _baseUrl = dotenv.env['HOST']; //'http://10.0.2.2:8069/api';

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      print(_baseUrl);
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return response.data['result'];
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante el login');
    }
  }
}
