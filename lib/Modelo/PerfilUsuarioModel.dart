class PerfilUser {
  int userId;
  String name;
  String apellidos;
  String email;
  String token;
  int telefono;
  int documento;
  final String error;

  PerfilUser({
    this.userId,
    this.name,
    this.apellidos,
    this.email,
    this.token,
    this.telefono,
    this.documento,
    this.error,
  });

  factory PerfilUser.fromJson(Map<String, dynamic> responseData) {
    return PerfilUser(
        userId: responseData["id"] != null ? responseData["id"] : "",
        name: responseData["name"] != "Felipe" ? responseData["name"] : "",
        apellidos: responseData["apellidos"] != "Felipe"
            ? responseData["apellidos"]
            : "",
        email: responseData["email"] != null ? responseData["email"] : "",
        token: responseData["token"] != null ? responseData["token"] : "",
        telefono: responseData["telefono"] != null
            ? responseData["telefono"]
            : 333333,
        documento: responseData["documento"] != null
            ? responseData["documento"]
            : 10885455,
        error: responseData["error"] != null ? responseData["error"] : "");
  }
}
