import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:domiciliarios_app/Modelo/SalidaModel.dart';
import 'package:domiciliarios_app/Modelo/UsuarioModel.dart';
import 'package:domiciliarios_app/Servicios/ApiServicio.dart';
//import 'package:restaurantes_tipoventas_app/Modelos/clUsuarios.dart';
//import 'package:restaurantes_tipoventas_app/Servicios/AuthAPI.dart';

//import 'Login_event.dart';
//import 'Login_state.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //final TextFieldType type;
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    /*try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoginBloc', error: _, stackTrace: stackTrace);
      yield state;
    }*/
    if (event is LoginButtonPressed) {

      print("hola tuu");
      yield LoginLoading();

      try {
        AuthAPIServicio apiService = new AuthAPIServicio();

        print(event.email);

        Salida usuarioLogin = await apiService.login(event.email, event.password);

        print("Respuesta login");
        print(usuarioLogin.code );
        //User dataUsuario = await AuthAPIServicio.login( event.email, event.password);
        //authenticationBloc.add(LoggedIn(token: token));

        if(usuarioLogin != null ){
          yield LoginInitial();

          if (usuarioLogin.code == 1) {

            yield LoginFinishedState();

          }
          else {
            yield ErrorLoginState(usuarioLogin.mens?.toString());
            //yield LoginInitial();
          }
        }

        /*AuthAPIServicio apiService = new AuthAPIServicio();
                              apiService.login(event.email,event.password).then((value) {
                                if (value != null) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });

                                  if (value.token.isNotEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text("Login Successful"));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                    //Mapa();
                                    Navigator.pushReplacementNamed(context, '/mapa');
                                  } else {
                                    final snackBar =
                                    SnackBar(content: Text(value.error));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                }
                              });*/

      } catch (error) {

        print(error);
        yield ErrorLoginState(error?.toString());
      }
    }

    /*if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }*/

    /*try {
      yield LoginStartingState();
      final password = UserSession.allUsers[this.userName];
      if (password == this.password) {
        UserSession.setLoggedIn();
        yield LoginFinishedState();
      } else {
        yield ErrorLoginState("invalidCredential");
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_?.toString());
    }*/
  }

  @override
  LoginState get initialState => LoginDefaultState();
}








abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password }';
}

/*
@immutable
abstract class LoginEvent {
  Stream<LoginState> applyAsync({LoginState currentState, LoginBloc bloc});
}

class AuthenticationEvent extends LoginEvent {
  final String userName;
  final String password;
  AuthenticationEvent({this.userName, this.password});
  @override
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async* {
    try {
      yield LoginStartingState();
      final password = UserSession.allUsers[this.userName];
      if (password == this.password) {
        UserSession.setLoggedIn();
        yield LoginFinishedState();
      } else {
        yield ErrorLoginState("invalidCredential");
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_?.toString());
    }
  }
}*/





abstract class LoginState extends Equatable {
  final List propss;
  LoginState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

class LoginDefaultState extends LoginState {
  LoginDefaultState() : super([]);

  @override
  String toString() => 'LoginDefaultState';
}

class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorLoginState';
}

class LoginStartingState extends LoginState {
  final String message;

  LoginStartingState({this.message}) : super([message]);

  @override
  String toString() => 'LoginStartingState';
}

class LoginFinishedState extends LoginState {
  final String message;

  LoginFinishedState({this.message}) : super([message]);

  @override
  String toString() => 'LoginStartingState';
}

class LoginLoading extends LoginState {}

class LoginInitial extends LoginState {}

class LoginValidatorState extends LoginState {
  final String userNameError;
  final String passwordError;
  final String text;
  //final TextFieldType type;

  LoginValidatorState({this.userNameError, this.passwordError, this.text = ''})
      : super([userNameError, passwordError, text]);

  LoginValidatorState copyWith(
      {String userNameError, String passwordError, String text}) {
    return LoginValidatorState(
      userNameError: userNameError ?? this.userNameError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  @override
  String toString() => 'LoginStartingState';
}



