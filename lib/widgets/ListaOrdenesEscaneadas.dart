import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:flutter/material.dart';

Widget setupAlertDialoadContainer( List<Orden> ordenes ) {
  return Container(
    height: 300.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: ordenes.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(ordenes[index].prefijo + ordenes[index].numero.toString()),
        );
      },
    ),
  );
}