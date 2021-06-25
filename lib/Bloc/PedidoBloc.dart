import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Modelo/Pedido.dart';
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

class EntregarPedido extends PedidoEvent {
  final Pedido pedido;
  EntregarPedido(this.pedido);
}

class ReasignarPedido extends PedidoEvent {
  final List<Pedido> pedidos;
  final String userId;
  final BuildContext c;
  ReasignarPedido(this.pedidos, this.userId, this.c);
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

         /*Ordenes.clear();
         asignarOrden ao = new asignarOrden(id: 0, prefijo: "F01", numero: 8888, latitud: 3.1, longitud: 4.7, usuaId: 1);
          print(ao);
          print("ao");
         Ordenes.add(ao);


         PedidoDomiclioRepository APIpedido = new PedidoDomiclioRepository();
         print("eres");
         print(Ordenes[0]);
         final int respuesta = await APIpedido.asignarPedido( Ordenes );
         print(respuesta);
         print("Salida");
         */

         final SharedPreferences prefs = await SharedPreferences.getInstance();
         String userId = prefs.getString("userId");

         final profile = await pedidoRepo.fetchPedidoUser(userId);
         print(profile);
         yield (PedidoLoaded(profile));
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
         final Salida respuesta = await apiPedido.entregarPedido( ordenes );
         print(respuesta);
         print("Salida");
         final profile = await pedidoRepo.fetchPedidoUser(event.pedido.usuario.toString());
         print(profile);
         yield (PedidoLoaded(profile));
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


         print("BLOC");
         print(event.pedidos[0].numero);

         print(event.pedidos[0].name);

          int cantPedidos = event.pedidos.length;


         //var item in list
         for (var i = 0; i < cantPedidos; i++) {
           if (event.pedidos[i].checked == true){

             Orden ao = new Orden(id: event.pedidos[i].id, prefijo: event.pedidos[i].restaurante, numero: event.pedidos[i].numero, latitud: ubicaion.latitude, longitud: ubicaion.longitude, usuaId: event.userId);
             print(ao);
             print("ao");
             ordenes.add(ao);
           }
         }

         if( ordenes.length == 0){
           showSnackBarMessage( "No hay pedidos seleccionados " ,  Colors.blue, Icons.warning_amber_outlined, event.c);
         }else{
           PedidoDomiclioRepository apiPedido = new PedidoDomiclioRepository();

           final Salida respuesta = await apiPedido.reasignarPedido( ordenes );
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
  final List<Pedido> pedido;
  const PedidoLoaded(this.pedido);
}

class PedidoRespuesta extends PedidoState {
  final String pedido;
  const PedidoRespuesta(this.pedido);
}

class PedidoError extends PedidoState {
  final String error;
  const PedidoError(this.error);
}
