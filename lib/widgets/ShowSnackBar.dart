import 'package:flutter/material.dart';

void showSnackBarMessage( String text, Color color, IconData icono, BuildContext context) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icono,
            size: 25,
            color: Colors.white,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight:
                FontWeight.bold
            ),
          ),
        ]
        ,)
      ,
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ),
  );

}