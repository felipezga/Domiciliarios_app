import 'dart:convert';

class Domicilio {
  int id;
  int userId;
  String nombre;
  String direccionEntrega;
  DateTime fecha;
  String estado;

  Domicilio(
      { this.id, this.userId,  this.nombre, this.direccionEntrega, this.fecha, this.estado});

  factory Domicilio.fromJson(Map<String, dynamic> json) => Domicilio(
        userId: json["userId"],
        id: json["id"],
        nombre: json["title"],
        direccionEntrega: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": direccionEntrega,
      };
}

List<Domicilio> albumFromJson(String str) =>
    List<Domicilio>.from(json.decode(str).map((x) => Domicilio.fromJson(x)));
String albumToJson(List<Domicilio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
