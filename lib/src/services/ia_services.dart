import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> editarImagenDesdeUrl(String imageUrl, String prompt) async {
  final url = Uri.parse('https://api.openai.com/v1/images/edits');
  
  try {
    // Descargamos la imagen desde la URL
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convertimos la imagen descargada en bytes
      final bytes = response.bodyBytes;

      // Convertimos los bytes a Base64
      final base64Image = base64Encode(bytes);

      // Enviamos la imagen en Base64 al API de OpenAI
      final apiResponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer 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', // Reemplaza con tu clave de proyecto
          'OpenAI-Organization': 'org-P7KK6seWPlyC6cYjzkgtXBHV'
        },
        body: jsonEncode({
          "model": "image-alpha-001",
          "image": base64Image,
          "prompt": prompt,
          "num_images": 1,
          "size": "512x512",
        }),
      );

      if (apiResponse.statusCode == 200) {
        final data = jsonDecode(apiResponse.body);
        return data['data'][0]['url']; // URL de la imagen editada
      } else {
        throw Exception('Error en la solicitud de edición de imagen');
      }
    } else {
      throw Exception('Error al descargar la imagen');
    }
  } catch (e) {
    throw Exception('Error de red o API');
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
