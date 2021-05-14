import 'package:domiciliarios_app/Bloc/PerfilUsuarioBloc.dart';
import 'package:domiciliarios_app/Bloc/ThemeBloc.dart';
import 'package:domiciliarios_app/Servicios/PerfilUsuarioServicio.dart';
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
    throw UnimplementedError();
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    print("ini");
    super.initState();
    //_loadTheme();
    _loadPerfilUsuario();

    /*Future.delayed(Duration.zero, () {
      this._loadDomicilios();
    });*/
  }

  _loadPerfilUsuario() async {
    print("load");
    context.read<ProfileBloc>().add(GetUser("mojombo"));
    print("loadeee");
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, theme) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.purple[200],
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
        body: EditProfilePage(),
      );
    });
  }

  EditProfilePage() {
    return Column(
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
            builder: (BuildContext context, ProfileState state) {
          if (state is ProfileError) {
            final error = state.error;
            /*String message = '${error}\nTap to Retry.';
                return ErrorTxt(
                  message: message,
                  onTap: _loadDomicilios(),
                );*/
          }
          if (state is ProfileLoaded) {
            //List<Domicilio> albums = state.domicilios;
            //return _list(albums);
            return Expanded(
              // wrap in Expanded
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
                                    image: NetworkImage(
                                      "data:image/jpeg;base64,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",
                                      //"https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                    ))),
                          ),
                          Positioned(
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
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 55,
                    ),

                    buildTextField("Nombre", state.profile.name, false),
                    buildTextField("Numero Documento", "10886592", false),
                    buildTextField("Correo", "alexd@gmail.com", false),
                    //buildTextField("Password", "********", true),
                    buildTextField("Telefono", "3145875258", false),
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
