import 'dart:async';

import 'package:domiciliarios_app/Modelo/EstadoPedidoDomiciliario.dart';
import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'UserLocationBloc.dart';


/*
abstract class TrackingEvent {}

class AddCatalogItemEvent extends TrackingEvent {
  final EstadoDomiciliario item;

  AddCatalogItemEvent(this.item);
}

class RemoveCatalogItemEvent extends TrackingEvent {
  final EstadoDomiciliario item;

  RemoveCatalogItemEvent(this.item);
}

class GetCatalogEvent extends TrackingEvent {}


class TrackingBloc {
  TrackingState _catalogState = TrackingState();

  StreamController<TrackingEvent> _input = StreamController();
  StreamController<List<EstadoDomiciliario>> _output =
  StreamController<List<EstadoDomiciliario>>.broadcast();

  StreamSink<TrackingEvent> get sendEvent => _input.sink;
  Stream<List<EstadoDomiciliario>> get catalogStream => _output.stream;

  CatalogBloc() {
    _input.stream.listen(_onEvent);
  }

  void _onEvent(TrackingEvent event) {
    if (event is AddCatalogItemEvent) {
      _catalogState.addToCatalog(event.item);
    } else if (event is RemoveCatalogItemEvent) {
      _catalogState.removeFromCatalog(event.item);
    }

    _output.add(_catalogState.catalog);
  }

  void dispose() {
    _input.close();
    _output.close();
  }
}

class TrackingState {
  //List<ItemModel> _catalog = [];
  List<EstadoDomiciliario> _esta_domi = [];

  TrackingState._();
  static TrackingState _instance = TrackingState._();
  factory TrackingState() => _instance;

  List<EstadoDomiciliario> get catalog => _esta_domi;

  void addToCatalog(EstadoDomiciliario itemModel) {
    _esta_domi.add(itemModel);
  }

  void removeFromCatalog(EstadoDomiciliario itemModel) {
    _esta_domi.remove(itemModel);
  }
}*/

abstract class TrackingEvent {}
/*
enum AlbumEvents {
  fetchAlbums,
}*/

class AddEstadoDomiciliario extends TrackingEvent {
  final String estadoTracking;
  final String descripcionTracking;
  final List<EstadoDomiciliario> listaTracking;

  AddEstadoDomiciliario({ this.estadoTracking, this.descripcionTracking, this.listaTracking});
}

class GetCatalogEvent extends TrackingEvent {}

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {

  TrackingBloc() : super(TrackingInitState());

  List<EstadoDomiciliario> estadosTracking;


  @override
  Stream<TrackingState> mapEventToState(TrackingEvent event) async* {
    if (event is AddEstadoDomiciliario) {
    //switch (event is AddEstadoDomiciliario) {
    //switch (TrackingEvent) {
     //case AddEstadoDomiciliario:
        yield TrackingLoading();
        try {

          LocationStarted();

          print("longitud");
          final _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print(_currentPosition);
          var lat = _currentPosition.latitude;
          var lon = _currentPosition.longitude;


          DateTime now = DateTime.now();
          String formattedDate = DateFormat('kk:mm').format(now);

          EstadoDomiciliario tracking = EstadoDomiciliario( lat, lon, event.descripcionTracking, event.estadoTracking, formattedDate  );


          print(event.listaTracking.length);
          event.listaTracking.add(tracking);
          //estados  = await EstadosTracking();
          yield TrackingLoaded(estaDomi: event.listaTracking);

        } catch (e) {
          yield AlbumsListError(
            error: UnknownException('Unknown Error'),
          );
        }
        //break;
       // case AddCatalogItemEvent
    }
  }
}

abstract class TrackingState extends Equatable {
  @override
  List<Object> get props => [];
}
class TrackingInitState extends TrackingState {}
class TrackingLoading extends TrackingState {}
class TrackingLoaded extends TrackingState {
  final List<EstadoDomiciliario> estaDomi;
  TrackingLoaded({this.estaDomi});
}

class AddTracking extends TrackingState {
}

class AlbumsListError extends TrackingState {
  final error;
  AlbumsListError({this.error});
}