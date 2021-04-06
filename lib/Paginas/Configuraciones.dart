import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:flutter/material.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../blocs/theme_bloc/theme_bloc.dart';
//import 'widgets/android_settings.dart';


/// Class: SettingsPage
/// Function: Widget representing the Settings Page
class Configuraciones extends StatefulWidget {

  static const String route = '/configuraciones';
  @override
  _ConfiguracionesState createState() => _ConfiguracionesState();
}

/// Class: _SettingsPageState
/// Function: Returns the state of the SettingsPage widget
class _ConfiguracionesState extends State<Configuraciones> {

  /// Standard build function for the state of the SettingsPage widget
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.purple[200],
          /*leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.drag_handle_sharp),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
          ),*/
          //automaticallyImplyLeading: false,
          title: Text(
            'CONFIGURACIONES',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, Configuraciones.route),
        body: Center(
          //child: Text("vamos carajo"),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return null;
            },
            child: AndroidSettings(theme: theme),
//              child: Platform.isIOS
//                  ? IOSSettings(theme: theme)
//                  : AndroidSettings(theme: theme),
          ),
        ),
      );
    });
  }
}


/// Class: AndroidSettings
/// Function: Returns the Settings Page layout for Android software
class AndroidSettings extends StatefulWidget {
  final ThemeState theme;
  AndroidSettings({this.theme});

  @override
  _AndroidSettingsState createState() => _AndroidSettingsState();
}

/// Class: _AndroidSettingsState
/// Function: Returns the state of the widget/layout
class _AndroidSettingsState extends State<AndroidSettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GeneralSettings(theme: widget.theme),
        AboutSettings(theme: widget.theme)
      ],
    );
  }
}

/// Class: GeneralSettings
/// Function: Represents the General settings section of the Settings Page
class GeneralSettings extends StatelessWidget {
  final ThemeState theme;
  GeneralSettings({this.theme});

  /// Standard build function for the GeneralSettings widget
  Widget build(BuildContext context) {
    var themeBloc = context.watch<ThemeBloc>();
    var isSwitched = theme.isDarkMode;
    print(isSwitched);
    return Column(children: <Widget>[
      ListTile(
        dense: true,
        leading: Text(
          'General',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
      ),
      ListTile(
        dense: true,
        leading: Icon(
          Icons.brightness_medium,
          color: theme.getTheme.hoverColor,
        ),
        title: Text('Dark Mode',
            style: TextStyle(color: theme.getTheme.hoverColor, fontSize: 16)),
        trailing: Switch(
          activeTrackColor: Colors.red,
          value: isSwitched,
          onChanged: (value) {
            isSwitched = value;
            themeBloc.add(ThemeEvent.toggle);
            //BlocProvider.of<ThemeBloc>(context).dispatch(ThemeChanged(theme: itemAppTheme));
          },
          activeColor: Colors.white,
          //material: (context, _) => MaterialSwitchData(activeTrackColor: Colors.green),
          //cupertino: (context, _) => CupertinoSwitchData(activeColor: Colors.green),
        ),
      ),
    ]);
  }
}


/// Class: AboutSettings
/// Function: Represents the About section of the Settings Page
class AboutSettings extends StatefulWidget {
  final ThemeState theme;
  AboutSettings({this.theme});

  @override
  _AboutSettingsState createState() => _AboutSettingsState();
}

/// Class: _AboutSettingsState
/// Function: Returns the state of the AboutSettings widget
class _AboutSettingsState extends State<AboutSettings> {
//  int devSettings = 0;

  /// Standard build function for the widget
  @override
  Widget build(BuildContext context) {
    var aboutSettingsList = <Widget>[

      ListTile(
        dense: true,
        leading: Text(
          'Politica de privacidad',
          style:
          TextStyle(color: widget.theme.getTheme.hoverColor, fontSize: 16),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(
                    theme: widget.theme,
                  )));
        },
      ),
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Version',
              style: TextStyle(
                  color: widget.theme.getTheme.hoverColor, fontSize: 16),
            ),
            Text(
              '0.0.1',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        onTap: () {
          /*if (kDebugMode) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SocketTest()));
          }*/

          // This was just to play around with some stuff, can add more later
//          setState(() {
//            devSettings++;
//            if (devSettings < 10) {
//              Toast.show(
//                "You are ${10 - devSettings} "
//                    "steps away from being a developer!",
//                context,
//                duration: Toast.LENGTH_LONG,
//                gravity: Toast.BOTTOM,
//              );
//            }
//
//          });
//          if (devSettings >= 10) {
//            Navigator.push(
//              context, MaterialPageRoute(builder: (context) => SocketTest()));
//          }
        },
      ),
    ];
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          leading: Text(
            'Informacion',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return null;
          },
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: aboutSettingsList.length,
            itemBuilder: (context, index) => aboutSettingsList[index],
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
                height: 4,
                indent: 15.0,
              );
            },
          ),
        )
      ],
    );
  }
}




/// Class: PrivacyPolicyPage
/// Function: Represents the Privacy Policy page
class PrivacyPolicyPage extends StatelessWidget {
  final ThemeState theme;
  PrivacyPolicyPage({this.theme});

  /// Launches the given url
  void _launch(String url) async {/*
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/
  }

  /// Builds the hyperlink based on the given link and text
  TextSpan buildHyperlink(String link, String placeholder) {
    return TextSpan(
      text: placeholder,
      style: TextStyle(
        color: Colors.blue,
      ),
      /*recognizer: TapGestureRecognizer()
        ..onTap = () {
          _launch(link);
        },*/
    );
  }

  /// Standard build function for the Privacy Policy page
  @override
  Widget build(BuildContext context) {
    var _subHeader = TextStyle(
      color: theme.getTheme.hoverColor,
    );

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          color: theme.getTheme.appBarTheme.color,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: theme.getTheme.hoverColor,
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        title: Text(
          'POLITICA DE PRIVACIDAD',
          style: TextStyle(
            color: theme.getTheme.hoverColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.getTheme.appBarTheme.color,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'MANUAL DE POLITICAS Y PROCEDIMIENTOS DE DATOS PERSONALES FRISBY S.A. EN CUMPLIMIENTO '
                    'DE LA LEY ESTATUTARIA 1581 DE 2012 REGLAMENTADA PARCIALMENTE POR EL DECRETO 1377DE 2013',
                    style: _subHeader),
                //buildHyperlink('https://webtech.union.rpi.edu', 'Web Technolgies Group'),
              ]),
            ),
            SizedBox(
              height: 20.0,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Aviso de Privacidad y Autorizacion para el tratamiento de datos personales '
                        ,
                    style: _subHeader),
              ]),
            ),
            SizedBox(height: 20.0),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Para mas informacion dirigase a: ',
                    style: _subHeader),
                buildHyperlink('www.frisby.com.co',
                    'Frisby'),
                TextSpan(text: '.', style: _subHeader),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

