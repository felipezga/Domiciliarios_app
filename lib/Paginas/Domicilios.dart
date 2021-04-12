//import 'package:flutter/widgets.dart';
//
//import 'package:flutter/cupertino.dart';

import 'package:domiciliarios_app/Bloc/DomicilioBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Modelo/DomicilioModel.dart';
import 'package:domiciliarios_app/Servicios/DomicilioServicio.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Domicilios extends StatelessWidget {
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

  /*_setTheme(bool darkTheme) async {
    AppTheme selectedTheme =
    darkTheme ? AppTheme.lightTheme : AppTheme.darkTheme;
    context.bloc<ThemeBloc>().add(ThemeEvent(appTheme: selectedTheme));
    Preferences.saveTheme(selectedTheme);
  }*/

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
            'DOMICILIOS',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, Domicilios.route),
        body: Container(
          child: _body(),
        ),
      );
    });
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<DomicilioBloc, DomicilioState>(
            builder: (BuildContext context, DomicilioState state) {
              if (state is DomicilioListError) {
                final error = state.error;
                String message = '${error.message}\nTap to Retry.';
                return ErrorTxt(
                  message: message,
                  onTap: _loadDomicilios(),
                );
              }
              if (state is DomicilioLoaded) {
                List<Domicilio> albums = state.domicilios;
                return _list(albums);
              }
              return Loading();
            }),
      ],
    );
  }

  Widget _list(List<Domicilio> domis) {
    return Expanded(
      child: ListView.builder(
        itemCount: domis.length,
        itemBuilder: (_, index) {
          Domicilio d = domis[index];
          return ListRow(domicilio: d);
        },
      ),
    );
  }
}


class ErrorTxt extends StatelessWidget {
  //
  final String message;
  final Function onTap;
  ErrorTxt({this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ListRow extends StatelessWidget {
  //
  final Domicilio domicilio;
  ListRow({this.domicilio});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( domicilio.nombre.toString()),
          Divider(),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}



