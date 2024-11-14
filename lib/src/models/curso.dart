class Cursos {
  final List<Curso>? cursos;

  Cursos({
    this.cursos,
  });

  factory Cursos.fromJson(Map<String, dynamic> json) => Cursos(
        cursos: List<Curso>.from(json["cursos"].map((x) => Curso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cursos": List<dynamic>.from(cursos!.map((x) => x.toJson())),
      };

  // Método para encontrar el primer curso que contenga el estudianteId en estudianteIds
  Curso? findCursoByEstudianteId(int estudianteId) {
    for (var curso in cursos!) {
      if (curso.estudianteIds != null &&
          curso.estudianteIds!.contains(estudianteId)) {
        return curso;
      }
    }
    return Curso();
  }
}

class Curso {
  final int? id;
  final String? grado;
  final String? paralelo;
  final int? gestion;
  final String? nivel;
  final String? displayName;
  final List<int>? materiaIds;
  final List<int>? estudianteIds;

  Curso({
    this.id,
    this.grado,
    this.paralelo,
    this.gestion,
    this.nivel,
    this.displayName,
    this.materiaIds,
    this.estudianteIds,
  });

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json["id"],
        grado: json["grado"],
        paralelo: json["paralelo"],
        gestion: json["gestion"],
        nivel: json["nivel"],
        displayName: json["display_name"],
        materiaIds: List<int>.from(json["materia_ids"].map((x) => x)),
        estudianteIds: List<int>.from(json["estudiante_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "grado": grado,
        "paralelo": paralelo,
        "gestion": gestion,
        "nivel": nivel,
        "display_name": displayName,
        "materia_ids": List<dynamic>.from(materiaIds!.map((x) => x)),
        "estudiante_ids": List<dynamic>.from(estudianteIds!.map((x) => x)),
      };
}
