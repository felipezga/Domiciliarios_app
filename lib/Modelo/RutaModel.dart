import 'package:domiciliarios_app/Modelo/OrdenModel.dart';

class Ruta {
  String id;
  String fecha;
  List<Orden> ordenes = [];

  Ruta(this.id, this.fecha, this.ordenes);
}
