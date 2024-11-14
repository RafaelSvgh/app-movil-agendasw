import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io';

Future<String> obtenerAnalisisDeImagen(
    File imageFile, String titulo, String detalle) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  String? key = dotenv.env['KEY_OPENAI'];
  String? org = dotenv.env['ORG_OPENAI'];

  try {
    // Codificar la imagen a base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Crear el cuerpo de la solicitud
    final body = jsonEncode({
      "model": "gpt-4o-mini", // Modelo adecuado (ajusta según tu necesidad)
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
                  "Quiero saber si esta imagen cumple en algunos aspectos con esta tarea, titulo: $titulo , detalle: $detalle, evalua la tarea en la escala del 0 al 100, no me ocupes mas de 500 caracteres",
            },
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
            },
          ],
        }
      ],
      "max_tokens": 300,
    });

    // Enviar la solicitud HTTP POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $key',
        'OpenAI-Organization': org ?? '',
      },
      body: body,
    );

    // Verificar la respuesta de la API
    if (response.statusCode == 200) {
      final responseData =
          utf8.decode(response.bodyBytes); // Decodificar correctamente en UTF-8
      final data = jsonDecode(responseData); // Decodificar la respuesta en JSON
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Error de API al analizar la imagen: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error de red o API: $e');
  }
}

Future<String> obtenerTrivia(String titulo, String detalle, int edad) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  String? key = dotenv.env['KEY_OPENAI'];
  String? org = dotenv.env['ORG_OPENAI'];
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $key', // Reemplaza con tu clave de proyecto
        'OpenAI-Organization': '$org'
      },
      body: jsonEncode({
        // "model": "gpt-4",
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content":
                //detalle y titulo********************
                //"Como estudiante quiero recursos educativos y estrategias de como implementar una tarea, enumerame los pasos o recursos y dime donde buscar mas informacion sobre el tema, dame el texto normal sin negritas, y haz un enfoque mas claro a los recursos de donde se saca la informacion al respecto, todo en español,  trata de darme a lo mucho 1200 caracteres, el titulo de mi tarea es: $titulo y el detalle es: $detalle"
                '''Necesito que me retornes un json para una trivia, con preguntas de cultura general para un alumno de $edad años de edad (incluye materias como lenguaje, matematicas,ciencias, historia, tecnologia, etc...), que tenga 5 preguntas y una sea la correcta, no me envies nada mas que el json, siguiendo este formato siempre: {
  "trivia": [
    {
      "pregunta": "¿alguna pregunta?",
      "opciones": [
        "respuesta",
        "respuesta",
        "respuesta",
        "respuesta"
      ],
      "respuesta_correcta": "respuesta"
    },
    {
      "pregunta": "alguna pregunta",
      "opciones": [
        "respuesta",
        "respuesta",
        "respuesta",
        "respuesta"
      ],
      "respuesta_correcta": "respuesta"
    }
  ]
}'''
          }
        ],
        "temperature": 0.7,
        "max_tokens": 600,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Error de API');
    }
  } catch (e) {
    throw Exception('Error de red o API');
  }
}

Future<String> obtenerSugerencias(String titulo, String detalle) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  String? key = dotenv.env['KEY_OPENAI'];
  String? org = dotenv.env['ORG_OPENAI'];
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $key', // Reemplaza con tu clave de proyecto
        'OpenAI-Organization': '$org'
      },
      body: jsonEncode({
        "model": "gpt-4",
        // "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content":
                //detalle y titulo********************
                "Como estudiante quiero recursos educativos y estrategias de como implementar una tarea, enumerame los pasos o recursos y dime donde buscar mas informacion sobre el tema, dame el texto normal sin negritas, y haz un enfoque mas claro a los recursos de donde se saca la informacion al respecto, todo en español,  trata de darme a lo mucho 1200 caracteres, el titulo de mi tarea es: $titulo y el detalle es: $detalle"
          }
        ],
        "temperature": 0.7,
        "max_tokens": 600,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Error de API');
    }
  } catch (e) {
    throw Exception('Error de red o API');
  }
}
