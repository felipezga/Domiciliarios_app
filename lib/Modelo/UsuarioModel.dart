class User {
  String userId;
  String name;
  String docIdent;
  String token;
  String salida;

  User({
    this.userId,
    this.name,
    this.docIdent,
    this.token,
    this.salida,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData["usuaId"] != null ? responseData["usuaId"] : "",
        name: responseData["propietario"] != null ? responseData["propietario"] : "",
        docIdent: responseData["usuaName"] != null ? responseData["usuaName"] : "",
        token: responseData["token"] != null ? responseData["token"] : "",
        salida: responseData["salida"] != null ? responseData["salida"]["codi"].toString() +"-" + responseData["salida"]["mens"]  : "");
  }
}
