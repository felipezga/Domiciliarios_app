import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:domiciliarios_app/widgets/drawer.dart';

//import '../widgets/drawer.dart';
/*
class AnimatedMapControllerPage extends StatefulWidget {
  static const String route = 'map_controller_animated';

  @override
  AnimatedMapControllerPageState createState() {
    return AnimatedMapControllerPageState();
  }
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin {
  // Note the addition of the TickerProviderStateMixin here. If you are getting an error like
  // 'The class 'TickerProviderStateMixin' can't be used as a mixin because it extends a class other than Object.'
  // in your IDE, you can probably fix it by adding an analysis_options.yaml file to your project
  // with the following content:
  //  analyzer:
  //    language:
  //      enableSuperMixins: true
  // See https://github.com/flutter/flutter/issues/14317#issuecomment-361085869
  // This project didn't require that change, so YMMV.

  static LatLng london = LatLng(51.5, -0.09);
  static LatLng paris = LatLng(48.8566, 2.3522);
  static LatLng dublin = LatLng(53.3498, -6.2603);

  MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: london,
        builder: (ctx) => Container(
          key: Key('blue'),
          child: FlutterLogo(),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: dublin,
        builder: (ctx) => Container(
          child: FlutterLogo(
            key: Key('green'),
            //colors: Colors.green,
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: paris,
        builder: (ctx) => Container(
          key: Key('purple'),
          child: FlutterLogo(
            //colors: Colors.purple
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Animated MapController')),
      drawer: buildDrawer(context, AnimatedMapControllerPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('London'),
                    onPressed: () {
                      _animatedMapMove(london, 10.0);
                    },
                  ),
                  MaterialButton(
                    child: Text('Paris'),
                    onPressed: () {
                      _animatedMapMove(paris, 5.0);
                    },
                  ),
                  MaterialButton(
                    child: Text('Dublin'),
                    onPressed: () {
                      _animatedMapMove(dublin, 5.0);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('Fit Bounds'),
                    onPressed: () {
                      var bounds = LatLngBounds();
                      bounds.extend(dublin);
                      bounds.extend(paris);
                      bounds.extend(london);
                      mapController.fitBounds(
                        bounds,
                        options: FitBoundsOptions(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 5.0,
                    maxZoom: 10.0,
                    minZoom: 3.0),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/

/*
class MapControllerPage extends StatefulWidget {
  static const String route = 'map_controller';

  @override
  MapControllerPageState createState() {
    return MapControllerPageState();
  }
}

class MapControllerPageState extends State<MapControllerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static LatLng london = LatLng(51.5, -0.09);
  static LatLng paris = LatLng(48.8566, 2.3522);
  static LatLng dublin = LatLng(53.3498, -6.2603);

  MapController mapController;
  double rotation = 0.0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: london,
        builder: (ctx) => Container(
          key: Key('blue'),
          child: FlutterLogo(),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: dublin,
        builder: (ctx) => Container(
          child: FlutterLogo(
            key: Key('green'),
            //colors: Colors.green,
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: paris,
        builder: (ctx) => Container(
          key: Key('purple'),
          child: FlutterLogo(
            //colors: Colors.purple
          ),
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('MapController')),
      drawer: buildDrawer(context, MapControllerPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('London'),
                    onPressed: () {
                      mapController.move(london, 18.0);
                    },
                  ),
                  MaterialButton(
                    child: Text('Paris'),
                    onPressed: () {
                      mapController.move(paris, 5.0);
                    },
                  ),
                  MaterialButton(
                    child: Text('Dublin'),
                    onPressed: () {
                      mapController.move(dublin, 5.0);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('Fit Bounds'),
                    onPressed: () {
                      var bounds = LatLngBounds();
                      bounds.extend(dublin);
                      bounds.extend(paris);
                      bounds.extend(london);
                      mapController.fitBounds(
                        bounds,
                        options: FitBoundsOptions(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                    child: Text('Get Bounds'),
                    onPressed: () {
                      final bounds = mapController.bounds;

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Map bounds: \n'
                              'E: ${bounds.east} \n'
                              'N: ${bounds.north} \n'
                              'W: ${bounds.west} \n'
                              'S: ${bounds.south}',
                        ),
                      ));
                    },
                  ),
                  Text('Rotation:'),
                  Expanded(
                    child: Slider(
                      value: rotation,
                      min: 0.0,
                      max: 360,
                      onChanged: (degree) {
                        setState(() {
                          rotation = degree;
                        });
                        mapController.rotate(degree);
                      },
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  maxZoom: 5.0,
                  minZoom: 3.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*

class PolylinePage extends StatelessWidget {
  static const String route = 'polyline';

  @override
  Widget build(BuildContext context) {
    var points = <LatLng>[
      LatLng(51.5, -0.09),
      LatLng(53.3498, -6.2603),
      LatLng(48.8566, 2.3522),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Polylines')),
      drawer: buildDrawer(context, PolylinePage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Polylines'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: points,
                          strokeWidth: 4.0,
                          color: Colors.purple),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*
class MovingMarkersPage extends StatefulWidget {
  static const String route = '/moving_markers';

  @override
  _MovingMarkersPageState createState() {
    return _MovingMarkersPageState();
  }
}

class _MovingMarkersPageState extends State<MovingMarkersPage> {
  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;

  @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex];
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: buildDrawer(context, MovingMarkersPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: <Marker>[_marker])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Marker> _markers = [
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(51.5, -0.09),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.3498, -6.2603),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(48.8566, 2.3522),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
];

*/


/*
class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  @override
  State<StatefulWidget> createState() {
    return TapToAddPageState();
  }
}

class TapToAddPageState extends State<TapToAddPage> {
  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {
    var markers = tappedPoints.map((latlng) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: latlng,
        builder: (ctx) => Container(
          child: FlutterLogo(),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Tap to add pins')),
      drawer: buildDrawer(context, TapToAddPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Tap to add pins'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13.0,
                    onTap: _handleTap),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }
}
*/

/*

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class MarkerAnchorPage extends StatefulWidget {
  static const String route = '/marker_anchors';
  @override
  MarkerAnchorPageState createState() {
    return MarkerAnchorPageState();
  }
}

class MarkerAnchorPageState extends State<MarkerAnchorPage> {
  AnchorPos anchorPos;

  @override
  void initState() {
    super.initState();
    anchorPos = AnchorPos.align(AnchorAlign.center);
  }

  void _setAnchorAlignPos(AnchorAlign alignOpt) {
    setState(() {
      anchorPos = AnchorPos.align(alignOpt);
    });
  }

  void _setAnchorExactlyPos(Anchor anchor) {
    setState(() {
      anchorPos = AnchorPos.exactly(anchor);
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(51.5, -0.09),
        builder: (ctx) => Container(
          child: FlutterLogo(),
        ),
        anchorPos: anchorPos,
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => Container(
          child: FlutterLogo(
            //colors: Colors.green,
          ),
        ),
        anchorPos: anchorPos,
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => Container(
          child: FlutterLogo(
            //colors: Colors.purple
          ),
        ),
        anchorPos: anchorPos,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Marker Anchor Points')),
      drawer: buildDrawer(context, MarkerAnchorPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                  'Markers can be anchored to the top, bottom, left or right.'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('Left'),
                    onPressed: () => _setAnchorAlignPos(AnchorAlign.left),
                  ),
                  MaterialButton(
                    child: Text('Right'),
                    onPressed: () => _setAnchorAlignPos(AnchorAlign.right),
                  ),
                  MaterialButton(
                    child: Text('Top'),
                    onPressed: () => _setAnchorAlignPos(AnchorAlign.top),
                  ),
                  MaterialButton(
                    child: Text('Bottom'),
                    onPressed: () => _setAnchorAlignPos(AnchorAlign.bottom),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text('Center'),
                    onPressed: () => _setAnchorAlignPos(AnchorAlign.center),
                  ),
                  MaterialButton(
                    child: Text('Custom'),
                    onPressed: () => _setAnchorExactlyPos(Anchor(80.0, 80.0)),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class PluginPage extends StatelessWidget {
  static const String route = 'plugins';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plugins')),
      drawer: buildDrawer(context, PluginPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  plugins: [
                    MyCustomPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MyCustomPluginOptions(text: "I'm a plugin!"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomPluginOptions extends LayerOptions {
  final String text;
  MyCustomPluginOptions({this.text = ''});
}

class MyCustomPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MyCustomPluginOptions) {
      var style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        color: Colors.red,
      );
      return Text(
        options.text,
        style: style,
      );
    }
    throw Exception('Unknown options type for MyCustom'
        'plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MyCustomPluginOptions;
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class CirclePage extends StatelessWidget {
  static const String route = 'circle';

  @override
  Widget build(BuildContext context) {
    var circleMarkers = <CircleMarker>[
      CircleMarker(
          point: LatLng(51.5, -0.09),
          color: Colors.blue.withOpacity(0.7),
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: 2000 // 2000 meters | 2 km
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Circle')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 11.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  CircleLayerOptions(circles: circleMarkers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class EsriPage extends StatelessWidget {
  static const String route = 'esri';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Esri')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Esri'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(45.5231, -122.6765),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class OfflineMapPage extends StatelessWidget {
  static const String route = '/offline_map';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Map')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                  'This is an offline map that is showing Anholt Island, Denmark.'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(56.704173, 11.543808),
                  minZoom: 12.0,
                  maxZoom: 14.0,
                  zoom: 13.0,
                  swPanBoundary: LatLng(56.6877, 11.5089),
                  nePanBoundary: LatLng(56.7378, 11.6644),
                ),
                layers: [
                  TileLayerOptions(
                    tileProvider: AssetTileProvider(),
                    maxZoom: 14.0,
                    urlTemplate: 'assets/map/anholt_osmbright/{z}/{x}/{y}.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class OnTapPage extends StatefulWidget {
  static const String route = 'on_tap';

  @override
  OnTapPageState createState() {
    return OnTapPageState();
  }
}

class OnTapPageState extends State<OnTapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static LatLng london = LatLng(51.5, -0.09);
  static LatLng paris = LatLng(48.8566, 2.3522);
  static LatLng dublin = LatLng(53.3498, -6.2603);

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: london,
        builder: (ctx) => Container(
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Tapped on blue FlutterLogo Marker'),
                ));
              },
              child: FlutterLogo(),
            )),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: dublin,
        builder: (ctx) => Container(
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Tapped on green FlutterLogo Marker'),
                ));
              },
              child: FlutterLogo(
                //colors: Colors.green,
              ),
            )),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: paris,
        builder: (ctx) => Container(
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Tapped on purple FlutterLogo Marker'),
                ));
              },
              child: FlutterLogo(
                //colors: Colors.purple
              ),
            )),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('OnTap')),
      drawer: buildDrawer(context, OnTapPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Try tapping on the markers'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  maxZoom: 5.0,
                  minZoom: 3.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class OverlayImagePage extends StatelessWidget {
  static const String route = 'overlay_image';

  @override
  Widget build(BuildContext context) {
    var overlayImages = <OverlayImage>[
      OverlayImage(
          bounds: LatLngBounds(LatLng(51.5, -0.09), LatLng(48.8566, 2.3522)),
          opacity: 0.8,
          imageProvider: NetworkImage(
              'https://images.pexels.com/photos/231009/pexels-photo-231009.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=300&w=600')),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Overlay Image')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('This is a map that is showing (51.5, -0.9).'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 6.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  OverlayImageLayerOptions(overlayImages: overlayImages)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
//import 'scale_layer_plugin_option.dart';
import 'dart:math';

import 'Mapa.dart';

class PluginScaleBar extends StatelessWidget {
  static const String route = '/plugin_scalebar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ScaleBarPlugins')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  plugins: [
                    ScaleLayerPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  ScaleLayerPluginOption(
                    lineColor: Colors.blue,
                    lineWidth: 2,
                    textStyle: TextStyle(color: Colors.blue, fontSize: 12),
                    padding: EdgeInsets.all(10),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';*/
//import './scalebar_utils.dart' as util;

class ScaleLayerPluginOption extends LayerOptions {
  TextStyle textStyle;
  Color lineColor;
  double lineWidth;
  final EdgeInsets padding;

  ScaleLayerPluginOption(
      {this.textStyle,
        this.lineColor = Colors.white,
        this.lineWidth = 2,
        this.padding});
}

class ScaleLayerPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ScaleLayerPluginOption) {
      return ScaleLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for ScaleLayerPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ScaleLayerPluginOption;
  }
}

class ScaleLayer extends StatelessWidget {
  final ScaleLayerPluginOption scaleLayerOpts;
  final MapState map;
  final Stream<Null> stream;
  final scale = [
    25000000,
    15000000,
    8000000,
    4000000,
    2000000,
    1000000,
    500000,
    250000,
    100000,
    50000,
    25000,
    15000,
    8000,
    4000,
    2000,
    1000,
    500,
    250,
    100,
    50,
    25,
    10,
    5
  ];

  ScaleLayer(this.scaleLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    var zoom = map.zoom;
    var distance = scale[max(0, min(20, zoom.round() + 2))].toDouble();
    var center = map.center;
    var start = map.project(center);
    var targetPoint =
    calculateEndingGlobalCoordinates(center, 90, distance);
    var end = map.project(targetPoint);
    var displayDistance = distance > 999
        ? '${(distance / 1000).toStringAsFixed(0)} km'
        : '${distance.toStringAsFixed(0)} m';
    double width = (end.x - start.x);

    return CustomPaint(
      painter: ScalePainter(
        width,
        displayDistance,
        lineColor: scaleLayerOpts.lineColor,
        lineWidth: scaleLayerOpts.lineWidth,
        padding: scaleLayerOpts.padding,
        textStyle: scaleLayerOpts.textStyle,
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  ScalePainter(this.width, this.text,
      {this.padding, this.textStyle, this.lineWidth, this.lineColor});
  final double width;
  final EdgeInsets padding;
  final String text;
  TextStyle textStyle;
  double lineWidth;
  Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = lineWidth;

    var sizeForStartEnd = 4;
    var paddingLeft = padding == null ? 0 : padding.left + sizeForStartEnd / 2;
    var paddingTop = padding == null ? 0 : padding.top;

    var textSpan = TextSpan(style: textStyle, text: text);
    var textPainter =
    TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    textPainter.paint(canvas,
        Offset(width / 2 - textPainter.width / 2 + paddingLeft, paddingTop));
    paddingTop += textPainter.height;
    var p1 = Offset(paddingLeft, sizeForStartEnd + paddingTop);
    var p2 = Offset(paddingLeft + width, sizeForStartEnd + paddingTop);
    // draw start line
    canvas.drawLine(Offset(paddingLeft, paddingTop),
        Offset(paddingLeft, sizeForStartEnd + paddingTop), paint);
    // draw middle line
    var middleX = width / 2 + paddingLeft - lineWidth / 2;
    canvas.drawLine(Offset(middleX, paddingTop + sizeForStartEnd / 2),
        Offset(middleX, sizeForStartEnd + paddingTop), paint);
    // draw end line
    canvas.drawLine(Offset(width + paddingLeft, paddingTop),
        Offset(width + paddingLeft, sizeForStartEnd + paddingTop), paint);
    // draw bottom line
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


//import 'dart:math';
//import 'package:latlong/latlong.dart';

const double piOver180 = PI / 180.0;
double toDegrees(double radians) {
  return radians / piOver180;
}

double toRadians(double degrees) {
  return degrees * piOver180;
}

LatLng calculateEndingGlobalCoordinates(
    LatLng start, double startBearing, double distance) {
  var mSemiMajorAxis = 6378137.0; //WGS84 major axis
  var mSemiMinorAxis = (1.0 - 1.0 / 298.257223563) * 6378137.0;
  var mFlattening = 1.0 / 298.257223563;
  // double mInverseFlattening = 298.257223563;

  var a = mSemiMajorAxis;
  var b = mSemiMinorAxis;
  var aSquared = a * a;
  var bSquared = b * b;
  var f = mFlattening;
  var phi1 = toRadians(start.latitude);
  var alpha1 = toRadians(startBearing);
  var cosAlpha1 = cos(alpha1);
  var sinAlpha1 = sin(alpha1);
  var s = distance;
  var tanU1 = (1.0 - f) * tan(phi1);
  var cosU1 = 1.0 / sqrt(1.0 + tanU1 * tanU1);
  var sinU1 = tanU1 * cosU1;

  // eq. 1
  var sigma1 = atan2(tanU1, cosAlpha1);

  // eq. 2
  var sinAlpha = cosU1 * sinAlpha1;

  var sin2Alpha = sinAlpha * sinAlpha;
  var cos2Alpha = 1 - sin2Alpha;
  var uSquared = cos2Alpha * (aSquared - bSquared) / bSquared;

  // eq. 3
  var A = 1 +
      (uSquared / 16384) *
          (4096 + uSquared * (-768 + uSquared * (320 - 175 * uSquared)));

  // eq. 4
  var B = (uSquared / 1024) *
      (256 + uSquared * (-128 + uSquared * (74 - 47 * uSquared)));

  // iterate until there is a negligible change in sigma
  double deltaSigma;
  var sOverbA = s / (b * A);
  var sigma = sOverbA;
  double sinSigma;
  var prevSigma = sOverbA;
  double sigmaM2;
  double cosSigmaM2;
  double cos2SigmaM2;

  for (;;) {
    // eq. 5
    sigmaM2 = 2.0 * sigma1 + sigma;
    cosSigmaM2 = cos(sigmaM2);
    cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;
    sinSigma = sin(sigma);
    var cosSignma = cos(sigma);

    // eq. 6
    deltaSigma = B *
        sinSigma *
        (cosSigmaM2 +
            (B / 4.0) *
                (cosSignma * (-1 + 2 * cos2SigmaM2) -
                    (B / 6.0) *
                        cosSigmaM2 *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM2)));

    // eq. 7
    sigma = sOverbA + deltaSigma;

    // break after converging to tolerance
    if ((sigma - prevSigma).abs() < 0.0000000000001) break;

    prevSigma = sigma;
  }

  sigmaM2 = 2.0 * sigma1 + sigma;
  cosSigmaM2 = cos(sigmaM2);
  cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;

  var cosSigma = cos(sigma);
  sinSigma = sin(sigma);

  // eq. 8
  var phi2 = atan2(
      sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
      (1.0 - f) *
          sqrt(sin2Alpha +
              pow(sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1, 2.0)));

  // eq. 9
  // This fixes the pole crossing defect spotted by Matt Feemster. When a
  // path passes a pole and essentially crosses a line of latitude twice -
  // once in each direction - the longitude calculation got messed up.
  // Using
  // atan2 instead of atan fixes the defect. The change is in the next 3
  // lines.
  // double tanLambda = sinSigma * sinAlpha1 / (cosU1 * cosSigma - sinU1 *
  // sinSigma * cosAlpha1);
  // double lambda = Math.atan(tanLambda);
  var lambda = atan2(
      sinSigma * sinAlpha1, (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1));

  // eq. 10
  var C = (f / 16) * cos2Alpha * (4 + f * (4 - 3 * cos2Alpha));

  // eq. 11
  var L = lambda -
      (1 - C) *
          f *
          sinAlpha *
          (sigma +
              C *
                  sinSigma *
                  (cosSigmaM2 + C * cosSigma * (-1 + 2 * cos2SigmaM2)));

  // eq. 12
  // double alpha2 = Math.atan2(sinAlpha, -sinU1 * sinSigma + cosU1 *
  // cosSigma * cosAlpha1);

  // build result
  var latitude = toDegrees(phi2);
  var longitude = start.longitude + toDegrees(L);

  // if ((endBearing != null) && (endBearing.length > 0)) {
  // endBearing[0] = toDegrees(alpha2);
  // }

  latitude = latitude < -90 ? -90 : latitude;
  latitude = latitude > 90 ? 90 : latitude;
  longitude = longitude < -180 ? -180 : longitude;
  longitude = longitude > 180 ? 180 : longitude;
  return LatLng(latitude, longitude);
}




