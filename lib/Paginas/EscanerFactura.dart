import 'package:domiciliarios_app/Bloc/DomicilioBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/DomicilioModel.dart';
import 'package:domiciliarios_app/Servicios/DomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/ErrorText.dart';
import 'package:domiciliarios_app/widgets/Loading.dart';
import 'package:domiciliarios_app/widgets/Scanner.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EscanearFactura extends StatelessWidget {
  @override

  static const String route = '/domicilios';
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => DomicilioBloc(domicilioRepo: DomicilioServices()),
      child: DomiciliosScreen(),
    );
    throw UnimplementedError();
  }
}

class DomiciliosScreen extends StatefulWidget {
  @override
  _DomicilioState createState() => _DomicilioState();
}

class _DomicilioState extends State<DomiciliosScreen> {
  //

  @override
  void initState() {
    print("ini");
    super.initState();
    //_loadTheme();
    _loadDomicilios();

    /*Future.delayed(Duration.zero, () {
      this._loadDomicilios();
    });*/
  }

  /*_loadTheme() async {
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: Preferences.getTheme()));
  }*/

  _loadDomicilios() async {
    print("load");
    context.read<DomicilioBloc>().add(DomicilioEvents.fetchDomicilios);
    print("loadeee");
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.purple[200],
          leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.red,),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
          ),
          //automaticallyImplyLeading: false,
          title: Text(
            'ESCANER',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, '/escaner'),
        body: Container(
          child: Center(
            child: Scanner()
            /*ElevatedButton(
                child: Text('Scan'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scanner()),
                  );
                }),*/
          ),
        ),
      );
    });
  }



}




