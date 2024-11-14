class User {
  final String sessionId;
  final int uid;
  final String name;
  final int edad;
  final String username;
  final String role;

  User({
    required this.sessionId,
    required this.uid,
    required this.name,
    required this.edad,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        sessionId: json["session_id"],
        uid: json["uid"],
        name: json["name"],
        edad: json["edad"],
        username: json["username"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "uid": uid,
        "name": name,
        "edad": edad,
        "username": username,
        "role": role,
      };
}
