import 'package:app_pedidos/HomePage.dart';
import 'package:app_pedidos/api/providers/UserProvider.dart';
import 'package:app_pedidos/api/request_objects/LoginRequest.dart';
import 'package:app_pedidos/api/response_objects/LoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

      bool submitting = false;

  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );

    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    emailController.text = "";
    passwordController.text = "";

    isLogin();
  }

  Future<Null> isLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isLogin') ?? false){
      Navigator.pushReplacementNamed(context, HomePage.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(40.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image(
                  image: AssetImage("assets/images/logo-fiori.png"),
                  width: _iconAnimation.value * 300,
                  height: _iconAnimation.value * 200,
                ),
                new Form(
                  child: new Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        decoration:
                            new InputDecoration(hintText: "Ingrese un email"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: new InputDecoration(
                            hintText: "Ingrese la contraseña"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            toggleSubmitState();
                            UserProvider().login(
                                LoginRequest(emailController.text,
                                    passwordController.text),
                                ([bool respuesta, LoginResponse datos]) async {
                              if (respuesta) {
                                if (datos.id != null) {
                                  print(datos.id);
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('userId', datos.id);
                                  prefs.setBool('isLogin', true);
                                  prefs.setString('username', datos.name);
                                  Navigator.pushReplacementNamed(context, HomePage.tag);
                                } else {
                                  toggleSubmitState();
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Lo sentimos las credenciales son incorrectas..!'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  // Scaffold.of(context).showSnackBar(new SnackBar(
                                  //     content: new Text(
                                  //         'Lo sentimos las credenciales son incorrectas..!')));
                                }
                              } else {
                                _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Ocurrió un error, intente más tarde'),
                                      duration: Duration(seconds: 3),
                                    ));
                                // Scaffold.of(context).showSnackBar(new SnackBar(
                                //     content: new Text(
                                //         'Ocurrió un error, intente más tarde')));
                              }
                            });

                            //Navigator.pop(context);
                            //Navigator.of(context).pushNamed(HomePage.tag);
                          },
                          color: Colors.green,
                          splashColor: Colors.white,
                          textColor: Colors.white,
                          child: const Text('Ingresar'),
                        ),
                      ),
                      Center(
                        child: !submitting 
                        ? new Container(color: Colors.grey,)
                        : const Center(child: const CircularProgressIndicator()),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
