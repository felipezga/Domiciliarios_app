import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';

class RutaPedido {
  int id;
  String estado;
  List<Pedido> pedidos = [];

  RutaPedido(this.id, this.estado, this.pedidos);

 /* Map<String, dynamic> toJson() => {
    "id": id,
    "estado" : estado,
    "ordenes": ordenes,
  };*/
}
