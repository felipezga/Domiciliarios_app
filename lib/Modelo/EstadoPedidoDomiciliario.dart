class EstadoDomiciliario{
  double lat;
  double long;
  String descripcion;
  String estado;
  String hora;

  EstadoDomiciliario(lat, long, descripcion, estado, hora){
    this.lat = lat;
    this.long = long;
    this.descripcion = descripcion;
    this.estado = estado;
    this.hora = hora;
  }
}