class Orden{
  int id;
  String estado;
  String prefijo;
  int numero;
  double latitud;
  double longitud;
  String usuaId;

  Orden({
    this.id,
    this.estado,
    this.prefijo,
    this.numero,
    this.latitud,
    this.longitud,
    this.usuaId
  });

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
    id: json["userId"],
    estado: json["id"],
    prefijo: json["id"],
    numero: json["title"],
    latitud : json["title"],
    longitud : json["title"],
    usuaId: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "estado": estado,
    "prefijo": prefijo,
    "numero": numero,
    "latitud" : latitud,
    "longitud" : longitud,
    "usuaId": usuaId,
  };
}
/*
List<asignarOrden> albumFromJson(String str) =>
    List<asignarOrden>.from(json.decode(str).map((x) => asignarOrden.fromJson(x)));
String albumToJson(List<Domicilio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}*/