import 'dart:async';

import 'package:domiciliarios_app/Bloc/EscaneoBloc.dart';
import 'package:domiciliarios_app/Modelo/ArgumentsModel.dart';
import 'package:domiciliarios_app/Modelo/OrdenModel.dart';
import 'package:domiciliarios_app/Paginas/EscanerFactura.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'EscanerWidgets.dart';
import 'Loading.dart';


class Scanner extends StatelessWidget {

  final Arguments opcion;

  Scanner({ Key key,    this.opcion }) : super(key: key);

  @override

  //static const String route = '/escaneo';
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => EscaneoBloc(),
      child: ScannerScreen( opcion : opcion ),
    );
  }
}


class ScannerScreen extends StatefulWidget {

  ScannerScreen({Key key, this.opcion}) : super(key: key);

  final Arguments opcion;

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerScreen> {

  String opc;
  List<Orden> ordenes = [];

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String result = "";

  @override
  Widget build(BuildContext context) {

    opc = widget.opcion.message;
    ordenes = widget.opcion.ordenes;
    print('Este es: ' + opc);

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 140.0
        : 300.0;

    return Stack(
      key: _scaffoldKey,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                            borderColor: Colors.red,
                            borderRadius: 2,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: scanArea),
                      ),
                      Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                    height: 120,
                  child:
                  Center(
                    child:
                    BlocBuilder<EscaneoBloc, EscaneoState>(
                        builder: (BuildContext context, EscaneoState state) {
                          if(state is EscaneoAsignado){
                            Timer(Duration(seconds: 3), () {
                              print("Yeah, this line is printed after 3 seconds");
                              Navigator.popAndPushNamed(context, '/ruta');
                            }
                            );
                          }
                          if(state is EscaneoError){
                            print('Error asignar95');
                            Timer(Duration(seconds: 3), () {
                              print("Yeah, this line is printed after 3 seconds");
                              Navigator.popAndPushNamed(context, EscanearFactura.route, arguments:  Arguments("asignar", [] ) );
                            });
                          }
                          if (state is EscaneoExistente) {
                            ordenes = state.listOrdenes;
                            String message = '${state.asignacion}';
                            return  ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                CardScan(message, Colors.yellow[300]),
                                SizedBox(height: 10),
                                //Divider(color: Theme.of(context).backgroundColor,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes, "camara"  ),
                                    ButtonScan(context, "Ordenes", Icons.list, ordenes, "camara"),
                                  ],
                                )
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context).textTheme.bodyText1.color, // background
                                          onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                          elevation: 5// foreground
                                      ),
                                      onPressed: (){
                                        //Navigator.popAndPushNamed(context, '/escaner');
                                        Navigator.popAndPushNamed(context, EscanearFactura.route, arguments:  Arguments("asignar", ordenes ) );
                                      },
                                      //width: 90,
                                      //height: 40,
                                      child: Center(
                                        child: Row( // Replace with a Row for horizontal icon + text
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text("Escanear   ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context).backgroundColor,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                            Icon( Icons.qr_code_scanner , size: 23, color: Theme.of(context).backgroundColor,),
                                          ],
                                        ),
                                      ),

                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Theme.of(context).textTheme.bodyText1.color, // background
                                          onPrimary: Theme.of(context).textTheme.bodyText1.color,
                                          elevation: 5// foreground
                                      ),
                                      onPressed: (){
                                        //Navigator.popAndPushNamed(context, '/mapa');
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext cont) {
                                              return AlertDialog(
                                                  title: Text('Ordenes Escaneadas'),
                                                  content: setupAlertDialoadContainer( ordenes ),
                                                  actions: <Widget>[
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
                                              );
                                            });
                                      },
                                      //width: 90,
                                      //height: 40,
                                      child: Center(
                                        child: Row( // Replace with a Row for horizontal icon + text
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Ordenes   ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context).backgroundColor,
                                                  fontWeight: FontWeight.w900
                                              ),
                                            ),
                                            //Icon( Icons.assignment_turned_in_outlined  , size: 23, color: Theme.of(context).backgroundColor,),
                                            Icon( Icons.list  , size: 23, color: Theme.of(context).backgroundColor,),

                                          ],
                                        ),
                                      ),

                                    ),
                                  ],)*/
                              ],
                            );
                          }
                          if (state is ErrorAgregar) {
                            String message = state.error;
                            ordenes = state.listOrdenes;

                            return  ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                CardScan(message, Colors.red[400]),
                                SizedBox(height: 10),
                                //Divider(color: Theme.of(context).backgroundColor,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes , "camara" ),
                                    ButtonScan(context, "Ordenes", Icons.list, ordenes, "camara"),
                                  ],
                                )
                              ],
                            );
                          }

                          if (state is EscaneoCompletado) {
                            String texto = "";
                            ordenes = state.listOrdenes;

                            if (opc == "entregar"){
                              texto = "ENTREGADO";
                            }else{
                              texto = "ASIGNADO";
                            }

                            return  ListView(
                              padding: const EdgeInsets.all(7),
                              children: <Widget>[
                                CardScan(state.respuesta +' '+texto +' EXITOSAMENTE  ', Colors.green[400]),
                                SizedBox(height: 10),
                                //Divider(color: Theme.of(context).backgroundColor,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonScan(context, "Escanear", Icons.qr_code_scanner, ordenes, "camara"  ),
                                    ButtonScan(context, "Ordenes", Icons.list, ordenes, "camara"),
                                  ],
                                ),
                              ],
                            );
                          }

                          if (state is Escaneando) {
                            return Loading();
                          }else{

                            String texto= "";
                            print("Llegamos aqui");
                            if (opc == "entregar"){
                              texto = "Escanea el codigo QR de la factura para hacer la entrega del pedido";

                            }else{
                              texto = "Escanea el codigo QR de la factura para asignar el pedido";
                            }

                            return Container(
                              padding: EdgeInsets.all(15.0),
                                child: Text( texto ,
                                  //textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      //color: Colors.white,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            );

                          }
                        }
                        ),
                  ),
                )
              ],
            ),
          ],
    );
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print("la data");
      print(scanData);

      controller.pauseCamera();

      //context.read<EscaneoBloc>().add(EscaneandoEvent());
      print(opc);
      BlocProvider.of<EscaneoBloc>(context).add(EscaneandoEvent(scanData.code, opc, ordenes ));

      /*setState(() {
        result = scanData.code;
      });*/

      /*if (await canLaunch(scanData.code)) {
        await launch(scanData.code);
        controller.resumeCamera();
      } else {
        showInSnackBar('Error: ${scanData.code}\n${scanData.code}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Could not find viable url'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Barcode Type: ${describeEnum(scanData.format)}'),
                    Text('Data: ${scanData.code}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((value) => controller.resumeCamera());
      }*/
    });
  }
}