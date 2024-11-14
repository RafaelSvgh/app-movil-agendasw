class Tutor {
  final int? id;
  final String? name;
  final int? userId;
  final List<Estudiante>? estudiantes;

  Tutor({
    this.id,
    this.name,
    this.userId,
    this.estudiantes,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        estudiantes: List<Estudiante>.from(
            json["estudiantes"].map((x) => Estudiante.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "estudiantes": List<dynamic>.from(estudiantes!.map((x) => x.toJson())),
      };
}

class Estudiante {
  final int? id;
  final String? name;
  final String? login;

  Estudiante({this.id, this.name, this.login});

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        id: json["id"],
        name: json["name"],
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "login": login};
}
