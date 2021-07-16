import 'package:domiciliarios_app/Bloc/LoginBloc.dart';
import 'package:domiciliarios_app/Modelo/LoginModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


/*class Login_state extends StatefulWidget{

}*/
/*
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //final Funciones funcion = Provider.of(context);
   // final Funciones funcion =  Funciones();

    return Scaffold(
        body: Stack(
          children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/icono_frisby.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only( bottom: 120, top: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('images/icono_frisby.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                ),
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          labelStyle: TextStyle(
                              fontSize: 15
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () {
                        /*if (snapshot.hasError) {
                          print(snapshot.error);
                          return null;
                        }
                        bloc.login(context);*/
                        //funcion.login(context);
                        Mapa();
                      },//since this is only a UI app
                      child: Text('SIGN IN',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.red,
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text('Forgot your password?',
                        style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.black,
                                    fontSize: 15,
                                  )
                              ),
                              TextSpan(
                                  text: "sign up",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Color(0xffff2d55),
                                    fontSize: 15,
                                  )
                              )
                            ]
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      backgroundColor:Colors.yellow[700],
    );
  }
}*/

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    print("Login");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color:  Colors.yellow[600],
          child: CustomScrollView(
            reverse: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  //children: <Widget>[
                    /*SizedBox(
                      height: 10.0,
                    ),*/
                    /*Image.asset(
                      'images/domiciliario.png',
                      height: 280,
                    ),*/
                    //Expanded(
                      child: BlocProvider(
                        create: (BuildContext context) => LoginBloc(),
                        child: LoginPage(),
                      ),
                    //),
                  //],
                ),
              )
            ],
          ),
        ),
      ),
    );

    /*return BlocProvider(
      create: (BuildContext context) => LoginBloc(),
      child: LoginBuilder(),
    );*/
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  _onLoginButtonPressed() {
    //Navigator.pushReplacementNamed(context, '/mapa');
    BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(email: _userNameController.text, password: _passwordController.text));
  }


  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    /*return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );*/

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        print("listener");
        if (state is LoginFinishedState) {
          /*Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => PaginaHome()),
                  (Route<dynamic> route) => false);*/

          Navigator.pushReplacementNamed(context, '/mapa');
        }else if (state is ErrorLoginState) {
          /*final snackBar = SnackBar(content: Text(state.errorMessage));
          scaffoldKey.currentState.showSnackBar(snackBar);*/
          print("Es aquiddd");
          print(state.errorMessage);

    // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.errorMessage),
            duration: Duration(seconds: 2),
            ));
        }
      },
        child: _uiSetup1( context),
    );



  }

  _uiSetup1(BuildContext context){
    return Stack(
      children: <Widget>[
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Card(
              //color: Colors.blue,
              //padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              //margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                margin: const EdgeInsets.all(20),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Container(
                  //color: Colors.green,
                  padding: EdgeInsets.all(12),
                  //margin: EdgeInsets.all(15),
                  height: 420,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/domiciliario.png',
                        height: 180,
                      ),
                      Center(
                          child: Text(
                            "APP DOMICILIARIOS",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Documento',
                        ),
                        controller: _userNameController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Clave',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context)
                                .accentColor
                                .withOpacity(0.4),
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        controller: _passwordController,
                        obscureText: hidePassword,
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      /*LoginButton(
                            userName: this._userNameController.text,
                            password: this._passwordController.text,
                          )*/
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(

                                height: 45,
                                child: state is LoginLoading
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                        child: Column(

                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 25.0,
                                                width: 25.0,
                                                child: CircularProgressIndicator()
                                            )
                                          ],
                                        ))
                                  ],
                                )
                                    :

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red, // background
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      elevation: 5// foreground
                                  ),
                                  onPressed: _onLoginButtonPressed,
                                  child: Center(
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("INGRESAR    ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.0,
                                              //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon( Icons.input_rounded , size: 25,),
                                      ],
                                    ),
                                  ),

                                )


                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              //)
            );
          },
          //bloc: BlocProvider.of<LoginBloc>(context),
        )
      ],
    );
  }



  /*Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //color: Theme.of(context).primaryColor,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        //SizedBox(height: 25),
                        Image.asset('images/domiciliario.png'),
                        /*Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline2,
                        ),*/
                        SizedBox(height: 20),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => loginRequestModel.email = input,
                          validator: (input) => !input.contains('@')
                              ? "Email Id should be valid"
                              : null,
                          decoration: new InputDecoration(
                            hintText: "Email Address",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style:
                          TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) =>
                          loginRequestModel.password = input,
                          validator: (input) => input.length < 3
                              ? "Password should be more than 3 characters"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*/

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

