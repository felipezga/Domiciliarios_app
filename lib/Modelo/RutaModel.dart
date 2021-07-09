import 'package:domiciliarios_app/Modelo/OrdenModel.dart';

class Ruta {
  String usuaId;
  List<Orden> ordenes = [];

  Ruta({this.usuaId, this.ordenes});

  Map<String, dynamic> toJson() => {
    "usuaId": usuaId,
    "ordenes": ordenes,
  };
}
