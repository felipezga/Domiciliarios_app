import 'package:domiciliarios_app/Modelo/DomicilioModel.dart';
import 'package:domiciliarios_app/Servicios/DomicilioServicio.dart';
import 'package:domiciliarios_app/Servicios/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

enum DomicilioEvents {
  fetchDomicilios,
}

abstract class DomicilioState extends Equatable {
  @override
  List<Object> get props => [];
}

class DomicilioInitState extends DomicilioState {

}

class DomicilioLoading extends DomicilioState {}

class DomicilioLoaded extends DomicilioState {
  final List<Domicilio> domicilios;
  DomicilioLoaded({this.domicilios});
}

class DomicilioListError extends DomicilioState {
  final error;
  DomicilioListError({this.error});
}

class DomicilioBloc extends Bloc<DomicilioEvents, DomicilioState> {
  final DomicilioRepo domicilioRepo;
  List<Domicilio> domis;


  DomicilioBloc({this.domicilioRepo}) : super(DomicilioInitState());

  @override
  Stream<DomicilioState> mapEventToState(DomicilioEvents event) async* {
    switch (event) {
      case DomicilioEvents.fetchDomicilios:
        print("domi");
        yield DomicilioLoading();
        try {
          domis = (await domicilioRepo.getDomicilioList()).cast<Domicilio>();
          yield DomicilioLoaded(domicilios: domis);
        } on SocketException {
          yield DomicilioListError(
            error: NoInternetException('No Internet'),
          );
        } on HttpException {
          yield DomicilioListError(
            error: NoServiceFoundException('No Service Found'),
          );
        } on FormatException {
          yield DomicilioListError(
            error: InvalidFormatException('Invalid Response format'),
          );
        } catch (e) {
          yield DomicilioListError(
            error: UnknownException('Unknown Error'),
          );
        }

        break;
    }
  }
}
