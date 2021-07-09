class Pedido {
  int id;
  int numero;
  String name;
  String usuario;
  String restaurante;
  String fecha;
  bool checked;
  String estado;


  Pedido({
    this.id,
    this.numero,
    this.name,
    this.usuario,
    this.restaurante,
    this.fecha,
    this.checked,
    this.estado
  });

  factory Pedido.fromJson( dynamic responseData) {
    //factory Pedido.fromJson(Map<String, dynamic> responseData) {
      print(responseData);
      print("esta qui");

      String rest = "";
      int num = 0;
      if (responseData['factura'] != "" ){
        var parts = responseData['factura'].split('-');
        rest = parts[0].trim();
        num =  int.parse(parts[1].trim());
      }

      print("holi");



      return Pedido(
          id: responseData['id'] != null ? responseData['id'] : 0,
          numero: num != 0 ? num : 0,
          name: responseData['factura'] != "" ? responseData['factura'] : "",
          usuario: responseData['usuaId'] != null ? responseData['usuaId'] : "",
          restaurante: rest != null ? rest : "",
          fecha: "" != null ? "" : "",
          checked: false,
          estado: responseData['estado'] != null ? responseData['estado'] : ""

      );

      /*return Pedido(
          id: responseData.id != null ? responseData.id : "",
          numero: num != 0 ? num : "",
          name: responseData != "Felipe" ? responseData : "",
          usuario: responseData.usuaId != null ? responseData.usuaId : "",
          restaurante: rest != null ? rest : "",
          fecha: responseData != null ? responseData : "");*/
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

List<Pedido> pedidosFromJson(dynamic  l) =>
    List<Pedido>.from( l.map((x) => Pedido.fromJson(x)));


//String PedidosToJson(List<Pedido> data) =>
//    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
