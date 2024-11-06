class User {
    final String sessionId;
    final int uid;
    final String name;
    final String username;

    User({
        required this.sessionId,
        required this.uid,
        required this.name,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        sessionId: json["session_id"],
        uid: json["uid"],
        name: json["name"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "uid": uid,
        "name": name,
        "username": username,
    };
}
