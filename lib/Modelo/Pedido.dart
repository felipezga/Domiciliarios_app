import 'dart:convert';

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

  factory Pedido.fromJson( dynamic responseData) {
    //factory Pedido.fromJson(Map<String, dynamic> responseData) {
      print(responseData);
      print("esta qui");

      return Pedido(
          numero: responseData != null ? 12 : "",
          name: responseData != "Felipe" ? responseData : "",
          apellidos: responseData != "Felipe" ? responseData : "",
          restaurante: responseData != null ? responseData : "",
          fecha: responseData != null ? responseData : "");
      /*return Pedido(
        numero: responseData["id"] != null ? responseData["id"] : "",
        name: responseData["name"] != "Felipe" ? responseData["name"] : "",
        apellidos: responseData["apellidos"] != "Felipe"
            ? responseData["apellidos"]
            : "",
        restaurante: responseData["email"] != null ? responseData["email"] : "",
        fecha: responseData["token"] != null ? responseData["token"] : "");*/

  }
}

List<Pedido> PedidosFromJson(dynamic  l) =>
    List<Pedido>.from( l.map((x) => Pedido.fromJson(x)));


//String PedidosToJson(List<Pedido> data) =>
//    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
