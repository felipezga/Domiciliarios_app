import 'package:domiciliarios_app/Bloc/EscaneoBloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Loading.dart';


class Scanner extends StatelessWidget {
  @override

  static const String route = '/escaneo';
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => EscaneoBloc(),
      child: ScannerScreen(),
    );
    throw UnimplementedError();
  }
}


class ScannerScreen extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<ScannerScreen> {
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

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Stack(
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
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: scanArea),
                      ),
                      /*Center(
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )*/
                    ],
                  ),
                ),

        Expanded(
          flex: 1,
          child: Center(
            child:
                BlocBuilder<EscaneoBloc, EscaneoState>(
                    builder: (BuildContext context, EscaneoState state) {
                      if (state is EscaneoError) {
                        final error = state.error;
                        String message = '${error.message}\nTap to Retry.';
                        return Text(message);
                      }
                      if (state is EscaneoCompletado) {
                        return Text('Scan a code: '+state.respuesta);
                      }

                      if (state is Escaneando) {
                        return Loading();
                      }else{
                        return Text('Scan a code'+result);

                      }

                      //return Loading();


                    }
                      ),
          ),
        )




              ],
            ),
          ],

    );
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {

      //context.read<EscaneoBloc>().add(EscaneandoEvent());
      BlocProvider.of<EscaneoBloc>(context).add(EscaneandoEvent(scanData.code));
      controller.pauseCamera();





      /*setState(() {
        result = scanData.code;
      });*/

      showInSnackBar('FELipoe: ${scanData.code}\n${scanData.code}');
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