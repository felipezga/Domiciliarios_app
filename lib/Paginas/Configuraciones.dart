import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:flutter/material.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../blocs/theme_bloc/theme_bloc.dart';
//import 'widgets/android_settings.dart';





class AndroidMaterialApp extends StatefulWidget {
  final ThemeData theme;

  final List<Widget> pageOptions;

  AndroidMaterialApp({this.theme, this.pageOptions});

  @override
  _AndroidMaterialAppState createState() => _AndroidMaterialAppState();
}

class _AndroidMaterialAppState extends State<AndroidMaterialApp> {
  int _selectedTab = 0;
  final _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.near_me),
      label: 'Map',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.event_note_rounded),
      label: 'Routes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      home: SafeArea(
        bottom: false,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: widget.theme.appBarTheme.color,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedTab,
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            items: _items,
          ),
          body: IndexedStack(
            index: _selectedTab,
            children: widget.pageOptions,
          ),
        ),
      ),
    );
  }

}








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
          automaticallyImplyLeading: false,
          title: Text(
            'Settings',
            style: TextStyle(
              //color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
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
        FeedbackSettings(theme: widget.theme),
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
          value: isSwitched,
          onChanged: (value) {
            isSwitched = value;
            themeBloc.add(ThemeEvent.toggle);
          },
          activeColor: Colors.white,
          //material: (context, _) => MaterialSwitchData(activeTrackColor: Colors.green),
          //cupertino: (context, _) => CupertinoSwitchData(activeColor: Colors.green),
        ),
      ),
    ]);
  }
}


/// Class: FeedbackSettings
/// Function: Represents the Feedback section of the Settings Page
class FeedbackSettings extends StatelessWidget {
  final ThemeState theme;
  FeedbackSettings({this.theme});

  /// Standard build function for the FeedbackSettings widget
  Widget build(BuildContext context) {
    var feedbackSettingsList = <Widget>[
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Send Feedback',
              style: TextStyle(color: theme.getTheme.hoverColor, fontSize: 16),
            ),
            Text(
              'Any comments? Send them here!',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      ListTile(
        dense: true,
        leading: Text(
          'Rate this app',
          style: TextStyle(color: theme.getTheme.hoverColor, fontSize: 16),
        ),
      ),
    ];
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          leading: Text(
            'Feedback',
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
            itemCount: feedbackSettingsList.length,
            itemBuilder: (context, index) => feedbackSettingsList[index],
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



//import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

//import 'package:flutter/foundation.dart';

//import '../../../blocs/theme_bloc/theme_bloc.dart';
//import 'faq_detail.dart';
//import 'privacy_detail.dart';
//import 'sockets_test.dart';

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
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FAQ',
              style: TextStyle(
                  color: widget.theme.getTheme.hoverColor, fontSize: 16),
            ),
            Text(
              'View frequently asked questions',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        onTap: () {
         /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FaqPage(
                    theme: widget.theme,
                  )));*/
        },
      ),
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'GitHub Repo',
              style: TextStyle(
                  color: widget.theme.getTheme.hoverColor, fontSize: 16),
            ),
            Text(
              'Interested in contributing?',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        onTap: () async {/*
          var url = 'https://github.com/wtg/Flutter_ShuttleTracker';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }*/
        },
      ),
      ListTile(
        dense: true,
        leading: Text(
          'Privacy Policy',
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
              '1.0.0',
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
            'About',
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
          'Privacy Policy',
          style: TextStyle(
            color: theme.getTheme.hoverColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
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
                    text: 'Shuttle Tracker is operated by the ',
                    style: _subHeader),
                buildHyperlink(
                    'https://webtech.union.rpi.edu', 'Web Technolgies Group'),
                TextSpan(
                    text: ' (WebTech), a committee of the Rensselaer Union '
                        'Student Senate. WebTech uses Google Analytics to'
                        ' gather anonymous metrics about the users of its '
                        'services. This information cannot and will not be '
                        'used to identify you or any specific user'
                        ' of the service.',
                    style: _subHeader),
              ]),
            ),
            SizedBox(
              height: 20.0,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'If you grant permission for Shuttle Tracker to '
                        'access your location, this information is used '
                        'for two purposes. The first is to indicate your '
                        'location on the map. The second is to enhance the '
                        'accuracy of vehicle tracking. The information '
                        'Shuttle Tracker gathers is limited to your '
                        "device's latitude, longitude, speed, and heading. "
                        'These data are associated with a random identifier'
                        ' that is generated whenever you open Shuttle '
                        'Tracker. In order to protect your privacy, no '
                        'two visits to Shuttle Tracker are associated. '
                        'This identifier is not used to identify any '
                        'specific user of the service. All data gathered'
                        ' are only analyzed in aggregate in order to '
                        'improve the quality of vehicle tracking for all'
                        ' users.',
                    style: _subHeader),
              ]),
            ),
            SizedBox(height: 20.0),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Any questions about this privacy policy should be '
                        'directed to ',
                    style: _subHeader),
                buildHyperlink('mailto:webtech@union.lists.rpi.edu',
                    'webtech@union.lists.rpi.edu'),
                TextSpan(text: '.', style: _subHeader),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

