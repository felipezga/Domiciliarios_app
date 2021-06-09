class asignarOrden{
  int id;
  String prefijo;
  int numero;
  double latitud;
  double longitud;
  int usuaId;

  asignarOrden({
    this.id,
    this.prefijo,
    this.numero,
    this.latitud,
    this.longitud,
    this.usuaId
  });

  factory asignarOrden.fromJson(Map<String, dynamic> json) => asignarOrden(
    id: json["userId"],
    prefijo: json["id"],
    numero: json["title"],
    latitud : json["title"],
    longitud : json["title"],
    usuaId: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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