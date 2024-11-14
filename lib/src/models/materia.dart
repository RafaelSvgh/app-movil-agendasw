class Materias {
  final String? status;
  final List<Materia>? materias;

  Materias({
    this.status,
    this.materias,
  });

  factory Materias.fromJson(Map<String, dynamic> json) => Materias(
        status: json["status"],
        materias: json["materias"] != null
            ? List<Materia>.from(
                json["materias"].map((x) => Materia.fromJson(x)))
            : [], // Si es null, asigna una lista vacía
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "materias": materias != null
            ? List<dynamic>.from(materias!.map((x) => x.toJson()))
            : [], // Si materias es null, asigna una lista vacía
      };
}

class Materia {
  final int? id;
  final String? name;
  final int? profesorId;
  final String? profesorName;

  Materia({
    this.id,
    this.name,
    this.profesorId,
    this.profesorName,
  });

  factory Materia.fromJson(Map<String, dynamic> json) => Materia(
        id: json["id"],
        name: json["name"],
        profesorId: json["profesor_id"],
        profesorName: json["profesor_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profesor_id": profesorId,
        "profesor_name": profesorName,
      };
}
