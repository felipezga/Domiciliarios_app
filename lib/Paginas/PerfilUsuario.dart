import 'package:domiciliarios_app/Bloc/PerfilUsuarioBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Servicios/PerfilUsuarioServicio.dart';
import 'package:domiciliarios_app/widgets/ErrorText.dart';
import 'package:domiciliarios_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerfilUsuario extends StatelessWidget {
  static const route = "/perfil";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("esere");
    return BlocProvider(
      create: (context) => ProfileBloc(profileRepo: PerfilUserRepository()),
      child: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    _loadPerfilUsuario();
  }

  _loadPerfilUsuario() async {
    print("Cargar usuario");
    context.read<ProfileBloc>().add(GetUser());
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.red,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }),
          //automaticallyImplyLeading: false,
          title: Text(
            'PERFIL',
            style: TextStyle(
              color: theme.getTheme.hoverColor,
              fontWeight: FontWeight.bold,
              //fontSize: 30,
            ),
          ),
        ),
        drawer: buildDrawer(context, PerfilUsuario.route),
        body: editProfilePage(),
      );
    });
  }

  editProfilePage() {
    return Column(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
            builder: (BuildContext context, ProfileState state) {
          if (state is ProfileError) {
            final error = state.error;
            String message = error+'\nTap to Retry.';
                return ErrorTxt(
                  message: message,
                  onTap: _loadPerfilUsuario(),
                );
          }
          if (state is ProfileLoaded) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new ExactAssetImage('images/domiciliario.png'),
                                    /*image: NetworkImage(
                                      "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                    )*/
                                )),
                          ),
                          /*Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Colors.green,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )),*/
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 55,
                    ),

                    buildTextField("Nombre", state.profile.name, false),
                    buildTextField("Numero Documento", state.profile.docIdent, false),
                    buildTextField("Correo", "", false),
                    //buildTextField("Password", "********", true),
                    buildTextField("Telefono", "", false),
                    SizedBox(
                      height: 35,
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {},
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )*/
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ],
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35, left: 30, right: 30),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              //color: Colors.black,
            )),
      ),
    );
  }
}
