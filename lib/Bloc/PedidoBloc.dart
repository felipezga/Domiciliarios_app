import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
import 'package:domiciliarios_app/Modelo/RutaPedidoEstado.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UserLocation.dart';
import 'package:domiciliarios_app/Servicios/FuncionesServicio.dart';
import 'package:domiciliarios_app/Servicios/PedidoDomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/ShowSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class PedidoEvent {}

class GetPedidoUser extends PedidoEvent {

  GetPedidoUser();
}

class HistorialRutaOrdeUser extends PedidoEvent {

  HistorialRutaOrdeUser();
}

class EntregarPedido extends PedidoEvent {
  final Pedido pedido;
  EntregarPedido(this.pedido);
}

class ActualizarPedido extends PedidoEvent{
  final String estado;
  final Pedido pedido;
  final BuildContext c;
  ActualizarPedido(this.estado, this.pedido, this.c);
}

class ActualizarRuta extends PedidoEvent{
  final String estado;
  final int idRuta;
  final BuildContext c;
  ActualizarRuta(this.estado, this.idRuta, this.c);
}

class ReasignarPedido extends PedidoEvent {
  final List<Pedido> pedidos;
  final int idRuta;
  final String userId;
  final String estaRuta;
  final BuildContext c;
  ReasignarPedido(this.pedidos, this.userId, this.idRuta, this.estaRuta, this.c);
}




 class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {

   final PedidoDomiclioRepository pedidoRepo;
   PedidoBloc({this.pedidoRepo}) : super(PedidoInitial());

   List<Orden> ordenes = [];

   @override
   Stream<PedidoState> mapEventToState(PedidoEvent event) async* {
     // TODO: implement mapEventToState
     try {
       if (event is GetPedidoUser) {
         print("Obtener Pedidos");
         yield (PedidoLoading());

         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         final profile = await pedidoRepo.fetchPedidoUser(userId);
         print(profile);
         yield (PedidoLoaded(profile));
       }

       if (event is HistorialRutaOrdeUser) {
         print("Historial");
         yield (PedidoLoading());

         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         final rutas = await pedidoRepo.historialRutaOrdeUser(userId);
         yield (RutasLoaded(rutas));

       }

       if (event is EntregarPedido) {
         print("Entregar Pedido");
         yield (PedidoLoading());

         ordenes.clear();

         Funciones funciones = Funciones();
         UserLocation ubicaion = UserLocation();

         ubicaion = await funciones.ubicacionLatLong();

         Orden ao = new Orden(id: event.pedido.id, prefijo: event.pedido.restaurante, numero: event.pedido.numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: event.pedido.usuario);
         print(ao);
         print("ao");
         ordenes.add(ao);


         PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();
         print("eres");
         print(ordenes[0]);
         final Salida respuesta = await apiPedido.ActuEstaOrde( ordenes );
         print(respuesta);
         print("Salida");
         final profile = await pedidoRepo.fetchPedidoUser(event.pedido.usuario.toString());
         print(profile);
         yield (PedidoLoaded(profile));
       }


       if (event is ActualizarPedido) {
         yield PedidoLoading();

         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         Funciones funciones = Funciones();
         UserLocation ubicaion = UserLocation();
         ubicaion = await funciones.ubicacionLatLong();

         print(event.pedido.numero.toString());
         print("usuario cambi");
         print(event.pedido.usuario);

         Orden ordenEnCurso = new Orden(id: event.pedido.id, estado: event.estado, prefijo: event.pedido.restaurante, numero: event.pedido.numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: userId);

         ordenes.add(ordenEnCurso);

         try {

           PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();

           final Salida respuesta = await apiPedido.ActuEstaOrde( ordenes );
           print(respuesta.code);
           print(respuesta.mens);

           String mens = "";
           Color col;
           IconData icono;
           if(respuesta.code == 1){

             String aux = " EN ";
             if( event.estado == "ENTREGADO"){
               aux = "  ";
             }
             mens = event.pedido.restaurante +'-'+ event.pedido.numero.toString() + aux + event.estado;
             col = Colors.green;
             icono = Icons.check_circle_outline;

             showSnackBarMessage( mens ,  col, icono, event.c);
             //Navigator.popAndPushNamed(event.c, '/mapa');

             // yield (EscaneoAsignado(mens: "OK"));

           }else{
             mens = respuesta.mens;
             col = Colors.red;
             icono = Icons.cancel_outlined;

             showSnackBarMessage( mens ,  col, icono, event.c);
             //Navigator.popAndPushNamed(event.c, '/mapa');

             // yield EscaneoError( error: mens  );
           }

           final rutaPedido = await apiPedido.fetchPedidoUser(userId);
           print(rutaPedido);
           yield (PedidoLoaded(rutaPedido));



         } catch (e) {
           /*yield AlbumsListError(
          error: UnknownException('Unknown Error'),
        );*/
         }

         //yield BotonStateEnSitio("EN SITIO");
       }

       if(event is ActualizarRuta){
         yield (PedidoLoading());

         try {

           final Salida respuesta = await pedidoRepo.ActuEstaRuta( event.idRuta, event.estado );
           print(respuesta.code);
           print(respuesta.mens);

           String mens = "";
           Color col;
           IconData icono;
           if(respuesta.code == 1){
             mens = " RUTA   " + event.estado;
             col = Colors.green;
             icono = Icons.check_circle_outline;

             showSnackBarMessage( mens ,  col, icono, event.c);
             //Navigator.popAndPushNamed(event.c, '/mapa');

             // yield (EscaneoAsignado(mens: "OK"));

           }else{
             mens = respuesta.mens;
             col = Colors.red;
             icono = Icons.cancel_outlined;

             showSnackBarMessage( mens ,  col, icono, event.c);
             //Navigator.popAndPushNamed(event.c, '/mapa');

             // yield EscaneoError( error: mens  );
           }

           final SharedPreferences prefs = await SharedPreferences.getInstance();
           String userId = prefs.getString("userId");

           final rutaPedido = await pedidoRepo.fetchPedidoUser(userId);
           print(rutaPedido);
           yield (PedidoLoaded(rutaPedido));



         } catch (e) {
           /*yield AlbumsListError(
          error: UnknownException('Unknown Error'),
        );*/
         }
       }

       if (event is ReasignarPedido) {
         print("Reasignar Pedido");
         yield (PedidoLoading());

         ordenes.clear();
         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         Funciones funciones = Funciones();
         UserLocation ubicaion = UserLocation();

         ubicaion = await funciones.ubicacionLatLong();

         int band = 0;
         String estadoRuta = "";


         print("BLOC");
         print(event.pedidos[0].numero);

         print(event.pedidos[0].name);
         int cantPedidos = event.pedidos.length;


         //var item in list
         for (var i = 0; i < cantPedidos; i++) {
           if( event.pedidos[i].estado != "ENTREGADO"){
             Orden ao = new Orden(id: event.pedidos[i].id, prefijo: event.pedidos[i].restaurante, numero: event.pedidos[i].numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: event.userId);
             print(ao);
             print("ao");
             ordenes.add(ao);
           }else{
             band = 1;
           }

           //VALIDACION PARA RECORRER LOS PEDIDOS SELECCIONADOS, <<Se quita porque se van a enviar todos los pedidos y no se necesita la validacion>>
           // if (event.pedidos[i].checked == true){
           //}
         }

         if( ordenes.length == 0){
           showSnackBarMessage( "No hay pedidos seleccionados " ,  Colors.blue, Icons.warning_amber_outlined, event.c);
         }else{
           PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();

           final Salida respuesta = await apiPedido.reasignarRutaOrdenes( ordenes,  event.idRuta, event.userId, band );
           //final Salida respuesta = await apiPedido.reasignarPedido( ordenes );

           print(respuesta.code);
           print(respuesta.mens);
           print("Reasignacion ");

           String mens = "";
           Color col;
           IconData icono;
           if(respuesta.code == 1){
             mens = "Reasignación exitosa!";
             col = Colors.green;
             icono = Icons.check_circle_outline;

           }else{
             mens = respuesta.mens;
             col = Colors.red;
             icono = Icons.cancel_outlined;
           }

           showSnackBarMessage( mens ,  col, icono, event.c);

         }

         final profile = await pedidoRepo.fetchPedidoUser(userId);
         print(profile);
         yield (PedidoLoaded(profile));
       }

     } on UserNotFoundException {
       yield (PedidoError('This User was Not Found!'));
     }
   }

 }


abstract class PedidoState {
  const PedidoState();
}

class PedidoInitial extends PedidoState {
  const PedidoInitial();
}

class PedidoLoading extends PedidoState {
  const PedidoLoading();
}

class PedidoLoaded extends PedidoState {
  final RutaPedido rutaPedido;
  const PedidoLoaded(this.rutaPedido);
}

class RutasLoaded extends PedidoState {
  final List<RutaPedido> rutaPedidos;
  const RutasLoaded(this.rutaPedidos);
}

class PedidoRespuesta extends PedidoState {
  final String pedido;
  const PedidoRespuesta(this.pedido);
}

class PedidoError extends PedidoState {
  final String error;
  const PedidoError(this.error);
}
