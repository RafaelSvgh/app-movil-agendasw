class Estudiantes {
  final String status;
  final List<Estudiante> estudiantes;

  Estudiantes({
    required this.status,
    required this.estudiantes,
  });

  factory Estudiantes.fromJson(Map<String, dynamic> json) => Estudiantes(
        status: json["status"],
        estudiantes: List<Estudiante>.from(
            json["top_estudiantes"].map((x) => Estudiante.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "top_estudiantes":
            List<dynamic>.from(estudiantes.map((x) => x.toJson())),
      };
}

class Estudiante {
  final int id;
  final String name;
  final int puntos;

  Estudiante({
    required this.id,
    required this.name,
    required this.puntos,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        id: json["id"],
        name: json["name"],
        puntos: json["puntos"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "puntos": puntos,
      };
}
