class Publicaciones {
  final List<Publicacion>? datos;
  final int? status;
  final String? message;

  Publicaciones({
    this.datos,
    this.status,
    this.message,
  });

  factory Publicaciones.fromJson(Map<String, dynamic> json) => Publicaciones(
        datos: List<Publicacion>.from(
            json["datos"].map((x) => Publicacion.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "datos": List<dynamic>.from(datos!.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Publicacion {
  final int? id;
  final String? titulo;
  final String? detalle;
  final String? fechaPublicacion;
  final String? fechaActividad;
  final int? gestion;
  final String? tipopublicacion;
  final String? user;
  final List<String>? grupos;
  final dynamic curso;
  final dynamic materia;
  final List<Multimedia>? multimedia;
  final List<String>? destinatarios;
  final List<Comentario>? comentarios;
  final List<Visualizacione>? visualizaciones;

  Publicacion({
    this.id,
    this.titulo,
    this.detalle,
    this.fechaPublicacion,
    this.fechaActividad,
    this.gestion,
    this.tipopublicacion,
    this.user,
    this.grupos,
    this.curso,
    this.materia,
    this.multimedia,
    this.destinatarios,
    this.comentarios,
    this.visualizaciones,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) => Publicacion(
        id: json["id"],
        titulo: json["titulo"],
        detalle: json["detalle"],
        fechaPublicacion: json["fecha_publicacion"],
        fechaActividad: json["fecha_actividad"],
        gestion: json["gestion"],
        tipopublicacion: json["tipopublicacion"],
        user: json["user"],
        grupos: List<String>.from(json["grupos"].map((x) => x)),
        curso: json["curso"],
        materia: json["materia"],
        multimedia: List<Multimedia>.from(
            json["multimedia"].map((x) => Multimedia.fromJson(x))),
        destinatarios: List<String>.from(json["destinatarios"].map((x) => x)),
        comentarios: List<Comentario>.from(
            json["comentarios"].map((x) => Comentario.fromJson(x))),
        visualizaciones: List<Visualizacione>.from(
            json["visualizaciones"].map((x) => Visualizacione.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "detalle": detalle,
        "fecha_publicacion": fechaPublicacion,
        "fecha_actividad": fechaActividad,
        "gestion": gestion,
        "tipopublicacion": tipopublicacion,
        "user": user,
        "grupos": List<dynamic>.from(grupos!.map((x) => x)),
        "curso": curso,
        "materia": materia,
        "multimedia": List<dynamic>.from(multimedia!.map((x) => x.toJson())),
        "destinatarios": List<dynamic>.from(destinatarios!.map((x) => x)),
        "comentarios": List<dynamic>.from(comentarios!.map((x) => x.toJson())),
        "visualizaciones":
            List<dynamic>.from(visualizaciones!.map((x) => x.toJson())),
      };

  bool usuarioEnVisualizaciones(String nombreUsuario) {
    return visualizaciones?.any((v) => v.usuario == nombreUsuario) ?? false;
  }
}

class Comentario {
  final String? comentario;
  final String? usuario;
  final String? fechaComentario;

  Comentario({
    this.comentario,
    this.usuario,
    this.fechaComentario,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        comentario: json["comentario"],
        usuario: json["usuario"],
        fechaComentario: json["fecha_comentario"],
      );

  Map<String, dynamic> toJson() => {
        "comentario": comentario,
        "usuario": usuario,
        "fecha_comentario": fechaComentario,
      };
}

class Multimedia {
  final String? nombreArchivo;
  final String? urlArchivo;

  Multimedia({
    this.nombreArchivo,
    this.urlArchivo,
  });

  factory Multimedia.fromJson(Map<String, dynamic> json) => Multimedia(
        nombreArchivo: json["nombre_archivo"],
        urlArchivo: json["url_archivo"],
      );

  Map<String, dynamic> toJson() => {
        "nombre_archivo": nombreArchivo,
        "url_archivo": urlArchivo,
      };
}

class Visualizacione {
  final String? usuario;
  final String? fechaVisualizacion;

  Visualizacione({
    this.usuario,
    this.fechaVisualizacion,
  });

  factory Visualizacione.fromJson(Map<String, dynamic> json) => Visualizacione(
        usuario: json["usuario"],
        fechaVisualizacion: json["fecha_visualizacion"],
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "fecha_visualizacion": fechaVisualizacion,
      };
}

List<Publicacion> filtrarPublicacionesPorTipos(
    List<Publicacion> publicaciones,
    String nombreUsuario,
    String grupoUsuario,
    int cursoUsuario,
    List<String> tiposPublicacion) {
  return publicaciones.where((publicacion) {
    // Verificar si el tipo de publicación coincide con alguno de los tipos en la lista
    bool esTipoCorrecto = tiposPublicacion.contains(publicacion.tipopublicacion);

    // Verificar si el grupo coincide
    bool perteneceAGrupo = publicacion.grupos!.contains(grupoUsuario);

    // Verificar si está en destinatarios
    bool esDestinatario = publicacion.destinatarios!.contains(nombreUsuario);

    // Verificar si coincide el curso y la materia
    bool perteneceACurso =
        (publicacion.curso != null && publicacion.curso == cursoUsuario);

    // Incluir la publicación si cumple todas las condiciones
    return esTipoCorrecto &&
        (perteneceAGrupo || esDestinatario || perteneceACurso);
  }).toList();
}

