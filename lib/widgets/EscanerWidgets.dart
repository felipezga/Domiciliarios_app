import 'package:domiciliarios_app/Bloc/EscaneoBloc.dart';
import 'package:domiciliarios_app/Modelo/ArgumentsModel.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:domiciliarios_app/Paginas/ScanDatawedge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ListaOrdenesEscaneadas.dart';


Widget ButtonScan( context, String txt , IconData icon, ordenes, tipoScan ){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: Theme.of(context).textTheme.bodyText1.color, // background
        onPrimary: Theme.of(context).textTheme.bodyText1.color,
        elevation: 5// foreground
    ),
    onPressed: (){
       if(txt == "Ordenes"){

         print("ordenes");
         return showDialog(
             context: context,
             builder: (BuildContext cont) {
               return AlertDialog(
                   title: Text(
                     'ORDENES ESCANEADAS',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                     ),),
                   content: setupAlertDialoadContainer( ordenes ),
                   actions: <Widget>[
                     Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           ElevatedButton(
                             child: Text("Enviar"),
                             onPressed: () {
                               BlocProvider.of<EscaneoBloc>(context).add(AsignarPedido(ordenes, context));
                               Navigator.of(cont).pop();
                               },
                           ),
                           ElevatedButton(
                             child: Text("Cerrar"),
                             onPressed: () {
                               Navigator.of(context).pop();
                               },
                           ),
                         ]
                     ),


                   ]
               );
             });
       }else{

         if (tipoScan == "laser"){
           Navigator.popAndPushNamed(context, ScannerLaser.route, arguments:  Arguments("asignar", ordenes ) );
         }else{
           Navigator.popAndPushNamed(context, EscanearFactura.route, arguments:  Arguments("asignar", ordenes ) );
         }



       }
    },
    //width: 90,
    //height: 40,
    child: Center(
      child: Row( // Replace with a Row for horizontal icon + text
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(txt ,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontWeight: FontWeight.w700
            ),
          ),
          Icon( icon, size: 23, color: Theme.of(context).backgroundColor,),
        ],
      ),
    ),

  );
}

Widget CardScan(message, color){
  return Card(
    color: color,
    child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  message,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600
                  )
              ),
              /*Icon( Icons.check_circle_outline , size: 20,
                                           //color: Colors.red,
                                       )*/
            ]
        )
    ),
  );
}