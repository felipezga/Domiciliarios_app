import 'package:flutter/material.dart';



class SplashPagina extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            mainAxisAlignment : MainAxisAlignment.center,
            children: [
              Image(
                image: new AssetImage("images/entregado.png"),
                width: 200,
                height: 200,
                color: null,
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
              Text(
                  "APP DOMICILIARIOS",
                style: TextStyle(
                  fontSize: 25,
                    //color: Colors.redAccent,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        )
      );

  }
}