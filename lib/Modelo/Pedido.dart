class Pedido {
  int numero;
  String name;
  String apellidos;
  String restaurante;
  String fecha;


  Pedido({
    this.numero,
    this.name,
    this.apellidos,
    this.restaurante,
    this.fecha,
  });

  factory Pedido.fromJson(Map<String, dynamic> responseData) {
    return Pedido(
        numero: responseData["id"] != null ? responseData["id"] : "",
        name: responseData["name"] != "Felipe" ? responseData["name"] : "",
        apellidos: responseData["apellidos"] != "Felipe"
            ? responseData["apellidos"]
            : "",
        restaurante: responseData["email"] != null ? responseData["email"] : "",
        fecha: responseData["token"] != null ? responseData["token"] : "");
  }
}
