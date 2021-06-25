import 'dart:async';


import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationEvent {}

class LocationStarted extends LocationEvent {}

class LocationChanged extends LocationEvent {
  final Position position;

  LocationChanged({@required this.position});
}

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoadInProgress extends LocationState {}

class LocationLoadSuccess extends LocationState {
  final Position position;

  LocationLoadSuccess({@required this.position});
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  //final Geolocator _geolocator;
  StreamSubscription _locationSubscription;

  LocationBloc() : super(LocationInitial());


  @override
  Stream<LocationState> mapEventToState(
      LocationEvent event,
      ) async* {
    if (event is LocationStarted) {
      yield LocationLoadInProgress();

      //FUNCION PARA ESCUCHAR LOS EVENTOS
      _locationSubscription?.cancel();
      _locationSubscription = Geolocator.getPositionStream().listen(
            (Position position) => add(
          LocationChanged(position: position),
        ),
      );

    } else if (event is LocationChanged) {
      print("Location cargado");
      print(event.position.latitude);
      print(event.position.longitude);
      yield LocationLoadSuccess(position: event.position);
      close();
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}