class Trivias {
    final List<Trivia> trivia;

    Trivias({
        required this.trivia,
    });

    factory Trivias.fromJson(Map<String, dynamic> json) => Trivias(
        trivia: List<Trivia>.from(json["trivia"].map((x) => Trivia.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "trivia": List<dynamic>.from(trivia.map((x) => x.toJson())),
    };
}

class Trivia {
    final String pregunta;
    final List<String> opciones;
    final String respuestaCorrecta;

    Trivia({
        required this.pregunta,
        required this.opciones,
        required this.respuestaCorrecta,
    });

    factory Trivia.fromJson(Map<String, dynamic> json) => Trivia(
        pregunta: json["pregunta"],
        opciones: List<String>.from(json["opciones"].map((x) => x)),
        respuestaCorrecta: json["respuesta_correcta"],
    );

    Map<String, dynamic> toJson() => {
        "pregunta": pregunta,
        "opciones": List<dynamic>.from(opciones.map((x) => x)),
        "respuesta_correcta": respuestaCorrecta,
    };
}
